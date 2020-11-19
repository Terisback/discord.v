module gateway

import term
import x.websocket
import discordv
import discordv.util

const (
	default_gateway = 'wss://gateway.discord.gg/?v=8&encoding=json'
)

pub struct Connection {
	token string
	intents discordv.Intent
pub:
	shard_id int
	shard_count int
mut:
	ws &websocket.Client
	session_id string
	sequence int
	heartbeat_acked bool = true
	heartbeat_interval u64 = 1000
	last_heartbeat u64
	resuming bool

	stop chan bool = chan bool{}

	dispatch_handler DispatchFn
	dispatch_receiver voidptr
}

pub fn new_connection(config discordv.Config, shard_id int, shard_count int) ?&Connection{
	mut ws := websocket.new_client(default_gateway)?
	mut conn := &Connection{
		token: config.token
		intents: config.intents
		shard_id: shard_id
		shard_count: shard_count
		ws: ws
	}
	conn.ws.on_open_ref(on_open, conn)
	conn.ws.on_error_ref(on_error, conn)
	conn.ws.on_message_ref(on_message, conn)
	conn.ws.on_close_ref(on_close, conn)
	return conn
}

pub fn (mut conn Connection) open() ?{
	go conn.run_heartbeat()?
	conn.ws.connect()?
	conn.ws.listen() or {
		util.log(term.bright_blue('[#$conn.shard_id] Websocket listen: $err'))
	}
	for {
		mut ws := websocket.new_client(default_gateway)?
		conn.ws = ws
		conn.ws.on_open_ref(on_open, conn)
		conn.ws.on_error_ref(on_error, conn)
		conn.ws.on_message_ref(on_message, conn)
		conn.ws.on_close_ref(on_close, conn)
		conn.ws.connect()?
		conn.ws.listen() or {
			util.log(term.bright_blue('[#$conn.shard_id] Websocket listen: $err'))
		}
	}
}

type DispatchFn = fn(receiver voidptr, packet Packet)

pub fn (mut conn Connection) on_dispatch(handler DispatchFn, receiver voidptr){
	conn.dispatch_handler = handler
	conn.dispatch_receiver = receiver
}