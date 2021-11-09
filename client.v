module discordv

import log
import term
import time
import eventbus
import gateway
import rest

// Config struct
pub struct Config {
pub mut:
	token                string         [required]
	intents              gateway.Intent = gateway.guilds | gateway.guild_messages
	shard_count          int = 1
	userdata             voidptr
	dispatchers_on_shard int = 1
}

// Client represents a connection to the Discord API
[heap]
pub struct Client {
	token   string
	intents gateway.Intent
pub:
	shard_count int
mut:
	events &eventbus.EventBus
	shards []&gateway.Shard
pub mut:
	rest     &rest.REST
	log      &log.Log
	userdata voidptr
}

// Creates a new Discord client
pub fn new(config Config) ?&Client {
	mut m_log := &log.Log{}
	$if dv_debug ? {
		m_log.set_level(.debug)
	} $else {
		m_log.set_level(.warn)
	}

	mut client := &Client{
		token: config.token
		intents: config.intents
		shard_count: config.shard_count
		userdata: config.userdata
		events: eventbus.new()
		rest: rest.new(config.token)
		log: m_log
	}

	for i in 0 .. config.shard_count {
		mut shard := gateway.new_shard(
			token: config.token
			intents: config.intents
			shard_id: i
			shards_in_total: config.shard_count
			dispatchers: config.dispatchers_on_shard
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

fn (mut client Client) shard_index(guild_id string) int {
	return (guild_id.int() >> 22) % client.shards.len
}

pub fn (mut client Client) shard(guild_id string) &gateway.Shard {
	return client.shards[client.shard_index(guild_id)]
}

pub fn (mut client Client) session_id(guild_id string) string {
	mut shard := client.shard(guild_id)
	return shard.get_session_id()
}

// Needed for logging purposes
fn prefix(level log.Level, colors_supported bool) string {
	if colors_supported {
		v := term.bold(term.rgb(95, 155, 230, 'v'))
		return term.bright_white('[discord.$v] ')
	}
	return '[discord.v] '
}
