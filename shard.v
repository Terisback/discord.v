module discordv

import x.websocket

const (
	default_gateway = 'wss://gateway.discord.gg:443/?v=8&encoding=json'
)

struct Shard {
	shard_id int
mut:
	client &Client
	stop chan bool = chan bool{}
	reconnect chan bool = chan bool{}
	ws &websocket.Client
	session_id string
	sequence int
	heartbeat_interval u64
	last_heartbeat u64
	heartbeat_acked bool = true
}

fn new_shard(mut client &Client, shard_id int) ?&Shard{
	mut ws := websocket.new_client(default_gateway) or {
		return error('[discord.v] Unavailable to instantiate websocket client')
	}

	mut s := &Shard{
		shard_id: shard_id
		client: client
		ws: ws
	}

	s.ws.on_open_ref(ws_on_open, s)
	s.ws.on_error_ref(ws_on_error, s)
	s.ws.on_message_ref(ws_on_message, s)
	s.ws.on_close_ref(ws_on_close, s)

	return s
}

fn (mut s Shard) start() ? {
	s.ws.connect()?
	go s.ws.listen()?
	go s.start_heartbeat()
}