module client

import discordv
import discordv.eventbus
import discordv.gateway

pub struct Client {
	token string
	intents discordv.Intent
mut:
	events &eventbus.EventBus
	conn &gateway.Connection
}

pub fn new(config discordv.Config) ?&Client{
	mut events := eventbus.new()
	shard := new_shard(config, events, 0, 1)?
	return shard
}

pub fn new_shard(config discordv.Config, events &eventbus.EventBus, shard_id int, shard_count int) ?&Client{
	mut conn := gateway.new_connection(config, shard_id, shard_count)?
	mut client := &Client{
		token: config.token
		intents: config.intents
		events: events
		conn: conn
	}

	client.conn.on_dispatch(on_dispatch, client)

	return client
}

pub fn (mut client Client) on(event discordv.Event, handler eventbus.EventHandlerFn){
	client.events.subscribe(event.str(), handler)
}

pub fn (mut client Client) open() ? {
	client.conn.open()?
}