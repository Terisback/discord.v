module gateway

import time
import log
import x.websocket
import discordv.eventbus
import gateway.packets
import sync

const (
	default_gateway = 'wss://gateway.discord.gg/?v=8&encoding=json'
)

pub struct Config {
	token string
	intents Intent = guilds | guild_messages
	shard_id int
	shards_in_total int = 1
	gateway string
}

pub struct Shard {
	gateway            string
	token              string
	intents            Intent
pub:
	id                 int
	total_count        int = 1
mut:
	reciever           voidptr = voidptr(0)
	event_queue        chan packets.Packet = chan packets.Packet{cap:64}
	events             &eventbus.EventBus
	ws                 &websocket.Client
	ws_log_level       log.Level = .info

	session_id         string
	sequence           int
	heartbeat_acked    bool = true
	heartbeat_interval u64 = 1000
	last_heartbeat     u64

	running            bool
	resuming           bool
	stop               chan bool = chan bool{}
pub mut:
	log                &log.Logger
}

// Create new Connection
pub fn new_shard(config Config) ?&Shard {
	gateway := if config.gateway != '' {config.gateway} else {default_gateway}
	mut ws := websocket.new_client(gateway) ?
	mut shard := &Shard{
		gateway: gateway
		token: config.token
		intents: config.intents
		id: config.shard_id
		total_count: config.shards_in_total
		ws: ws
		events: eventbus.new()
		log: &log.Log{}
	}
	shard.ws.logger.set_level(shard.ws_log_level)
	shard.ws.on_open_ref(on_open, shard)
	shard.ws.on_error_ref(on_error, shard)
	shard.ws.on_message_ref(on_message, shard)
	shard.ws.on_close_ref(on_close, shard)
	return shard
}

// Opens Websocket to Discord Gateway (It will wait till close signal)
pub fn (mut shard Shard) run() thread {
	go shard.run_dispatcher()
	go shard.run_websocket() 
	return go shard.run_heartbeat()
}

fn (mut shard Shard) run_dispatcher() {
	for !shard.running {
		packet := <-shard.event_queue or {
			shard.log.warn('Dispatcher #$shard.id: Unable to pop event from event queue')
		}
		shard.dispatch(&packet)
	}
}

fn (mut shard Shard) run_websocket() {
	defer { shard.ws.free() }
	for !shard.running {
		shard.ws.connect() or {
			shard.log.warn('Websocket #$shard.id: Unable to connect to gateway')
			continue
		}
		shard.ws.listen() or { 
			shard.log.warn('#$shard.id Websocket listen: $err') 
		}
	}
}

// Run heartbeat loop. Will execute till stop signal recieved
fn (mut shard Shard) run_heartbeat() {
	for {
		mut stop := false
		status := shard.stop.try_pop(stop)
		if status == .success {
			shard.running = false
			shard.ws.close(1000, 'close() was called') or {}
			return
		}
		time.sleep(50 * time.millisecond)
		if shard.ws.state in [.connecting, .closing, .closed] {
			shard.heartbeat_acked = true
			shard.heartbeat_interval = 1000
			shard.last_heartbeat = 0
			continue
		}
		now := time.now().unix_time_milli()
		if now - shard.last_heartbeat > shard.heartbeat_interval {
			if shard.heartbeat_acked != true {
				if shard.ws.state == .open {
					shard.ws.close(1000, "heartbeat ack didn't come") or {
						panic(err)
					}
				}
				continue
			}
			heartbeat := packets.Packet{
				op: .heartbeat
				data: shard.sequence
			}
			message := heartbeat.to_json()
			shard.ws.write_string(message) or { 
				shard.log.error('Something went when tried to write to websocket: $err') 
			}
			shard.last_heartbeat = now
			shard.heartbeat_acked = false
		}
	}
}

// Send publish from Websocket
fn (mut shard Shard) dispatch(data voidptr){
	if shard.reciever != voidptr(0) {
		shard.events.publish('dispatch', shard.reciever, data)
	} else {
		shard.events.publish('dispatch', shard, data)
	}
}

pub fn (mut shard Shard) set_ws_log_level(level log.Level) {
	shard.ws_log_level = level
	shard.ws.logger.set_level(level)
}

// Send close signal (It doesn't close immediately)
pub fn (mut shard Shard) close() {
	shard.stop <- true
}
