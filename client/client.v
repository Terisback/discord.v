module client

import discordv
import discordv.client.rest
import discordv.eventbus
import discordv.gateway
import discordv.types

pub struct Client {
	token string
	intents types.Intent
pub:
	shard_id int
	shard_count int
mut:
	events &eventbus.EventBus
	conn &gateway.Connection
	rest &rest.REST
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
		shard_id: shard_id
		shard_count: shard_count
		events: events
		conn: conn
		rest: rest.new(config.token)
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