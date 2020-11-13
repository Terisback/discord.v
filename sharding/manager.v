module sharding

import discordv
import discordv.client
import discordv.eventbus

pub struct ShardingManager {
	token string
	intents discordv.Intent
mut:
	events &eventbus.EventBus
	//cache &cache.Cache
	clients []&client.Client
	shard_count int
}

pub fn new_manager(config discordv.Config) ?&ShardingManager{
	//for ___ {
		// Create shard
		// sleep 5 seconds https://discord.com/developers/docs/topics/gateway#rate-limiting
	//}
}