module discordv

import sync
import log
import term
import time
import discordv.eventbus
import discordv.fancylog
import discordv.gateway
import discordv.gateway.types
import discordv.rest

// Config struct
pub struct Config {
pub mut:
	token       string
	intents     types.Intent = guilds | guild_messages
	shard_count int = 1
}

// Client represents a connection to the Discord API
pub struct Client {
	token       string
	intents     types.Intent
pub:
	shard_count int
mut:
	events      &eventbus.EventBus
	shards      []&gateway.Connection
pub mut:
	rest        &rest.REST
	log			&fancylog.Log
}

// Creates a new Discord client
pub fn new(config Config) ?&Client {
	mut client := &Client{
		token: config.token
		intents: config.intents
		shard_count: config.shard_count
		events: eventbus.new()
		rest: rest.new(config.token)
		log: fancylog.new()
	}
	$if dv_debug ? {
		client.log.set_level(.debug)
	}
	client.log.set_prefix_func(prefix)
	for i in 0 .. config.shard_count {
		mut conn := gateway.new_connection(config.token, config.intents, i, config.shard_count) ?
		conn.log = client.log
		conn.set_ws_log_level(.warn)
		conn.set_reciever(client)
		conn.on_hello(on_hello)
		conn.on_dispatch(on_dispatch)
		client.shards << conn
	}
	return client
}

// Creates a websocket connection to Discord
pub fn (mut client Client) open() ? {
	for i in 0 .. client.shards.len {
		go client.shards[i].open() ?
		time.sleep(5)
	}
	mut wg := sync.new_waitgroup()
	wg.add(1)
	wg.wait()
}

// Needed for logging purposes
fn prefix(level log.Level, colors_supported bool) string {
	if colors_supported {
		v := term.bold(term.rgb(95, 155, 230, 'v'))
		return term.bright_white('[discord.$v] ')
	}
	return '[discord.v] '
}