module client

import x.websocket
import discordv
import discordv.eventbus

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
	shard_id int
	shard_count int = 1

	reconnect chan bool = chan bool{}
	stop chan bool = chan bool{}
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
	}

	client.ws.on_open_ref(ws_on_open, client)
	client.ws.on_error_ref(ws_on_error, client)
	client.ws.on_message_ref(ws_on_message, client)
	client.ws.on_close_ref(ws_on_close, client)

	return client
}

pub fn new_shard(config discordv.Config, shard_id int, shard_count int) ?&Client{
	mut client := new(config)?
	client.shard_id = shard_id
	client.shard_count = shard_count
	return client
}

pub fn (mut client Client) on(event discordv.Event, handler eventbus.EventHandlerFn){
	client.events.subscribe(event.str(), handler)
}

pub fn (mut client Client) run() ? {
	client.ws.connect()?
	go client.ws.listen()?
	client.start_heartbeat()?
}