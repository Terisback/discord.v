module discordv

import time
import x.websocket

const (
	default_gateway = 'wss://gateway.discord.gg:443/?v=8&encoding=json'
)

pub struct Client {
	token string
	intents Intent
mut:
	events map[string][]EventHandler
	ws &websocket.Client
	session_id string
	sequence int
	heartbeat_interval u64
	last_heartbeat u64
}

pub fn new(token string) ?&Client{
	mut ws := websocket.new_client(default_gateway) or {
		return error('[discord.v] Unavailable to instantiate websocket client')
	}

	mut c := &Client{
		token: token,
		events: map[string][]EventHandler{}
		ws: ws
		intents: 0
	}	

	c.ws.on_open_ref(ws_on_open, c)
	c.ws.on_error_ref(ws_on_error, c)
	c.ws.on_message_ref(ws_on_message, c)
	c.ws.on_close_ref(ws_on_close, c)

	return c
}

pub fn (mut c Client) on(event Event, handler EventHandler){
	c.events[event.str()] << handler
}

pub fn (mut c Client) stay_connected() ? {
	println('[discord.v] Connecting to gateway...')
	c.ws.connect()?
	go c.ws.listen()?
	for true {
		time.sleep(1)
		if time.now().unix_time_milli() - c.last_heartbeat > c.heartbeat_interval {
			heartbeat := HeartbeatPacket {
				op: Op.heartbeat,
				data: c.sequence
			}
			println("[discord.v] Heartbeat $c.sequence")
			message := heartbeat.to_json()
			c.ws.write(message.bytes(), .text_frame)
			c.last_heartbeat = time.now().unix_time_milli()
		}
	}
}