module gateway

import time
import log
import x.websocket
import eventbus
import gateway.packets

const (
	default_gateway = 'wss://gateway.discord.gg/?v=8&encoding=json'
)

pub struct Config {
	token           string [required]
	intents         Intent = guilds | guild_messages
	shard_id        int
	shards_in_total int = 1
	gateway         string
	dispatchers     int = 1
}

[heap]
pub struct Shard {
	gateway string
	token   string
	intents Intent
pub:
	id          int
	total_count int = 1
mut:
	reciever     voidptr
	events       chan DispatchArgs
	dispatchers  []&Dispatcher
	eb           &eventbus.EventBus
	ws           &websocket.Client
	ws_log_level log.Level = .info

	session_id         string
	sequence           int
	heartbeat_acked    bool = true
	heartbeat_interval u64  = 1000
	last_heartbeat     u64

	running  bool
	resuming bool
	stop     chan bool = chan bool{}
pub mut:
	log &log.Logger
}

// Create new Connection
pub fn new_shard(config Config) ?&Shard {
	gateway := if config.gateway != '' { config.gateway } else { gateway.default_gateway }
	mut ws := websocket.new_client(gateway) ?
	mut shard := &Shard{
		gateway: gateway
		token: config.token
		intents: config.intents
		id: config.shard_id
		total_count: config.shards_in_total
		ws: ws
		events: chan DispatchArgs{}
		eb: eventbus.new()
		log: &log.Log{}
	}
	for _ in 0 .. config.dispatchers {
		shard.dispatchers << new_dispatcher(shard.eb, shard.events)
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
	for mut dispatcher in shard.dispatchers {
		dispatcher.run()
	}
	go shard.run_websocket()
	return go shard.run_heartbeat()
}

fn (mut shard Shard) run_websocket() {
	defer {
		shard.ws.free()
	}
	for !shard.running {
		shard.ws.connect() or {
			shard.log.warn('Websocket #$shard.id: Unable to connect to gateway')
			continue
		}
		shard.ws.listen() or { shard.log.warn('#$shard.id Websocket listen: $err') }
	}
}

// Run heartbeat loop. Will execute till stop signal recieved
fn (mut shard Shard) run_heartbeat() {
	for {
		mut stop := false
		status := shard.stop.try_pop(mut stop)
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
					shard.ws.close(1000, "heartbeat ack didn't come") or { panic(err) }
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
fn (mut shard Shard) dispatch(data voidptr) {
	if shard.reciever != voidptr(0) {
		shard.events <- DispatchArgs{
			reciever: shard.reciever
			data: data
		}
	} else {
		shard.events <- DispatchArgs{
			reciever: shard
			data: data
		}
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

// Return the shard's session id
pub fn (mut shard Shard) get_session_id() string {
	return shard.session_id
}

// Add packet handler to Dispatch packet
pub fn (mut shard Shard) on_dispatch(handler fn (voidptr, &packets.Packet)) {
	shard.eb.subscribe('dispatch', handler)
}

// Set reciever, it will provided as first argument to dispatch handlers
pub fn (mut shard Shard) set_reciever(reciever voidptr) {
	shard.reciever = reciever
}
