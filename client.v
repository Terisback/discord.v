module discordv

import log
import term
import time
import discordv.eventbus
import discordv.gateway
import discordv.rest

// Config struct
pub struct Config {
pub mut:
	token       string
	intents     gateway.Intent = gateway.guilds | gateway.guild_messages
	shard_count int = 1
	userdata    voidptr
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
	log			&log.Logger
	userdata	voidptr
}

// Creates a new Discord client
pub fn new(config Config) ?&Client {
	mut client := &Client{
		token: config.token
		intents: config.intents
		shard_count: config.shard_count
		userdata: config.userdata
		events: eventbus.new()
		rest: rest.new(config.token)
		log: &log.Log{}
	}
	$if dv_debug ? {
		client.log.set_level(.debug)
	} $else {
		client.log.set_level(.warn)
	}
	for i in 0 .. config.shard_count {
		mut conn := gateway.new_shard(
			token: config.token, 
			intents: config.intents, 
			id: i, 
			shards_in_total: config.shard_count
		) ?
		conn.log = client.log
		$if dv_ws_debug ? {
			conn.set_ws_log_level(.debug)
		} $else {
			conn.set_ws_log_level(.warn)
		}
		conn.set_reciever(client)
		conn.on_hello(on_hello)
		conn.on_dispatch(on_dispatch)
		client.shards << conn
	}
	return client
}

// Creates a websocket connection to Discord
pub fn (mut client Client) open() ? {
	mut shards := []thread ?{}
	for i in 0 .. client.shards.len {
		shards << go client.shards[i].open()
		time.sleep(5 * time.second)
	}
	for shard in shards {
		shard.wait() or { /* nothing */ }
	}
}

// Needed for logging purposes
fn prefix(level log.Level, colors_supported bool) string {
	if colors_supported {
		v := term.bold(term.rgb(95, 155, 230, 'v'))
		return term.bright_white('[discord.$v] ')
	}
	return '[discord.v] '
}
