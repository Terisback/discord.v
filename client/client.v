module client

import time
import sync
import x.websocket
import discordv
import discordv.eventbus
import discordv.structs

const (
	default_gateway = 'wss://gateway.discord.gg/?v=8&encoding=json'
)

pub struct Client {
	token string
	intents discordv.Intent
mut:
	events &eventbus.EventBus
	ws &websocket.Client
	session_id string
	sequence int
	heartbeat_acked bool = true
	heartbeat_interval u64
	last_heartbeat u64

	wg &sync.WaitGroup

	resuming bool
	reconnect chan bool = chan bool{}
	stop chan bool = chan bool{}

	//rl &RateLimit

pub mut:
	shard_id int
	shard_count int = 1
}

pub fn new(config discordv.Config) ?&Client{
	mut ws := websocket.new_client(default_gateway) or {
		return error('[discord.v] Unavailable to instantiate websocket client')
	}

	mut client := &Client{
		token: config.token
		intents: config.intents
		events: eventbus.new()
		ws: ws
		wg: sync.new_waitgroup()
	}

	client.ws.on_open_ref(ws_on_open, client)
	client.ws.on_error_ref(ws_on_error, client)
	client.ws.on_message_ref(ws_on_message, client)
	client.ws.on_close_ref(ws_on_close, client)
	client.wg.add(1)

	return client
}

pub fn new_shard(config discordv.Config, events &eventbus.EventBus, wg &sync.WaitGroup, shard_id int, shard_count int) ?&Client{
	mut ws := websocket.new_client(default_gateway) or {
		return error('[discord.v] Unavailable to instantiate websocket client')
	}

	mut client := &Client{
		token: config.token
		intents: config.intents
		events: events
		ws: ws
		shard_id: shard_id
		shard_count: shard_count
		wg: wg
	}

	//client.ws.logger.set_output_level(.fatal)
	client.ws.on_open_ref(ws_on_open, client)
	client.ws.on_error_ref(ws_on_error, client)
	client.ws.on_message_ref(ws_on_message, client)
	client.ws.on_close_ref(ws_on_close, client)
	client.wg.add(1)

	return client
}

pub fn (mut client Client) on(event discordv.Event, handler eventbus.EventHandlerFn){
	client.events.subscribe(event.str(), handler)
}

fn (mut client Client) reconnect(resume bool) {
	client.reconnect <- resume
}

pub fn (mut client Client) open() ? {
	client.ws.connect()?
	go client.ws.listen()?
	for {
		select {
			_ := <- client.stop {
				client.wg.done()
				break
			}
			resume := <- client.reconnect {
				time.sleep(5)
				if client.ws.state in [.open, .connecting]{
					client.ws.close(GatewayCloseCode.reconnect, "Oops, client isn't closed yet") or {}
				}
				client.resuming = resume
				client.events.publish(
					discordv.Event.reconnect.str(), client, 
					structs.Reconnect{resumed: resume})
				client.ws = websocket.new_client(default_gateway) or {
					return error('[discord.v] Unavailable to instantiate websocket client')
				}
				client.ws.on_open_ref(ws_on_open, client)
				client.ws.on_error_ref(ws_on_error, client)
				client.ws.on_message_ref(ws_on_message, client)
				client.ws.on_close_ref(ws_on_close, client)
				client.ws.connect()?
				go client.ws.listen()?
			}
			> 5 * time.second {
				now := time.now().unix_time_milli()
				if now - client.last_heartbeat > client.heartbeat_interval {
					if client.heartbeat_acked != true {
						go client.reconnect(true)
						continue
					}
					heartbeat := HeartbeatPacket {
						op: Op.heartbeat,
						data: client.sequence
					}
					message := heartbeat.to_json()
					client.ws.write(message.bytes(), .text_frame)
					client.last_heartbeat = now
					client.heartbeat_acked = false
				}
			}
		}
	}
}

pub fn (mut client Client) close() {
	client.stop <- true
}