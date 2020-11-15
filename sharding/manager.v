module sharding

import time
import sync
import discordv
import discordv.client
import discordv.eventbus
import discordv.util

pub struct ShardingManager {
	token string
mut:
	events &eventbus.EventBus
	//cache &cache.Cache
	clients []&client.Client
	shard_count int
	wg &sync.WaitGroup
}

pub fn new_manager(config discordv.Config) ?&ShardingManager{
	mut sham := &ShardingManager{
		token: config.token
		events: eventbus.new()
		shard_count: config.shard_count
		wg: sync.new_waitgroup()
	}

	for i in 0..config.shard_count{
		// add cache into clients
		mut client := client.new_shard(config, sham.events, sham.wg, i, config.shard_count)?
		sham.clients << client
	}

	return sham
}

pub fn (mut sham ShardingManager) on(event discordv.Event, handler eventbus.EventHandlerFn){
	sham.events.subscribe(event.str(), handler)
}

pub fn (mut sham ShardingManager) open() ?{
	util.log('[SHAM] Starting shards...')
	for i in 0..sham.shard_count{
		go sham.clients[i].open()?
		time.sleep(5) // sleep for 5 seconds
	}
	util.log('[SHAM] Initialized all shards')
	sham.wg.wait()
}

pub fn (mut sham ShardingManager) close() {
	for i in 0..sham.shard_count{
		sham.clients[i].close()
	}
}