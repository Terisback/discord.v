module discordv

import sync
import eventbus

pub struct Config {
pub mut:
	token string
	shard_count int
	intents Intent = intents.guilds | intents.guild_messages
}

pub struct Client {
	token string
	intents Intent
mut:
	wg &sync.WaitGroup
	events &eventbus.EventBus
	shards []&Shard
}

pub fn new(config Config) ?&Client{
	mut c := &Client{
		token: config.token
		intents: config.intents
		wg: sync.new_waitgroup()
		events: eventbus.new()
	}

	mut cfg := config
	if cfg.shard_count == 0 {
		cfg.shard_count = c.get_shard_count()?
	}

	mut shards := []&Shard{}
	for i in 0..cfg.shard_count {
		mut shard := new_shard(mut c, i)?
		shards << shard
	}
	c.shards = shards

	c.wg.add(cfg.shard_count)

	return c
}

pub fn (mut c Client) on(event Event, handler eventbus.EventHandlerFn){
	c.events.subscriber.subscribe(event.str(), handler)
}

pub fn (mut c Client) stay_connected() ? {
	for i in 0..c.shards.len{
		c.shards[i].start()?
	}
	c.wg.wait()
}

pub fn (mut c Client) run() ? {
	go c.stay_connected()?
}

pub fn (mut c Client) stop() {
	for i in 0..c.shards.len{
		c.shards[i].stop <- true
	}
}