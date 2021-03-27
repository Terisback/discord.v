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
	intents     gateway.Intent
pub:
	shard_count int
mut:
	events      &eventbus.EventBus
	shards      []&gateway.Shard
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
	mut m_log := &log.Log{}
	$if dv_debug ? {
		m_log.set_level(.debug)
	} $else {
		m_log.set_level(.warn)
	}
	client.log = m_log
	for i in 0 .. config.shard_count {
		mut shard := gateway.new_shard(
			token: config.token, 
			intents: config.intents, 
			shard_id: i, 
			shards_in_total: config.shard_count
		) ?
		shard.log = client.log
		$if dv_ws_debug ? {
			shard.set_ws_log_level(.debug)
		} $else {
			shard.set_ws_log_level(.warn)
		}
		shard.set_reciever(client)
		shard.on_dispatch(on_dispatch)
		client.shards << shard
	}
	return client
}

// Creates a websocket connection to Discord
pub fn (mut client Client) run() []thread {
	mut shards := []thread{}
	for i in 0 .. client.shards.len {
		shards << client.shards[i].run()
		time.sleep(5 * time.second)
	}
	return shards
}

// Needed for logging purposes
fn prefix(level log.Level, colors_supported bool) string {
	if colors_supported {
		v := term.bold(term.rgb(95, 155, 230, 'v'))
		return term.bright_white('[discord.$v] ')
	}
	return '[discord.v] '
}
