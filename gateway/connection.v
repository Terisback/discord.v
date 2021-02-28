module gateway

import log
import x.websocket
import discordv.eventbus
import discordv.gateway.types
import discordv.fancylog
import sync

const (
	default_gateway = 'wss://gateway.discord.gg/?v=8&encoding=json'
)

// Represents Shard Connection to Discord Gateway
pub struct Connection {
	token              string
	intents            types.Intent
pub:
	shard_id           int
	shard_count        int
mut:
	events             &eventbus.EventBus
	reciever           voidptr
	ws                 &websocket.Client
	ws_log_level 	   log.Level = .info
	session_id         string
	sequence           int
	heartbeat_acked    bool = true
	heartbeat_interval u64 = 1000
	last_heartbeat     u64
	resuming           bool
	stop               chan bool = chan bool{}
pub mut:
	log &fancylog.Log
}

// Create new Connection
pub fn new_connection(token string, intents types.Intent, shard_id int, shard_count int) ?&Connection {
	mut ws := websocket.new_client(default_gateway) ?
	mut conn := &Connection{
		token: token
		intents: intents
		shard_id: shard_id
		shard_count: shard_count
		ws: ws
		events: eventbus.new()
		log: fancylog.new()
	}
	return conn
}

// Opens Websocket to Discord Gateway (It will wait till close signal)
pub fn (mut conn Connection) open() ? {
	// Never handled optional
	go conn.run_heartbeat()
	for {
		mut ws := websocket.new_client(default_gateway) ?
		conn.ws = ws
		conn.ws.logger.set_level(conn.ws_log_level)
		conn.ws.on_open_ref(on_open, conn)
		conn.ws.on_error_ref(on_error, conn)
		conn.ws.on_message_ref(on_message, conn)
		conn.ws.on_close_ref(on_close, conn)
		conn.ws.connect() ?
		conn.ws.listen() or { conn.log.warn('#$conn.shard_id Websocket listen: $err') }
	}
}

pub fn (mut conn Connection) set_ws_log_level(level log.Level) {
	conn.ws_log_level = level
	conn.ws.logger.set_level(level)
}

// Send close signal (It doesn't close immediately)
pub fn (mut conn Connection) close() {
	conn.stop <- true
}
