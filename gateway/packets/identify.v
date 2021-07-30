module packets

import os

// Websocket Identify packet data
pub struct Identify {
pub:
	token      string
	properties IdentifyProperties = IdentifyProperties{}
	intents    int
	shard      []int = [0, 1]
}

// Identify packet properies
pub struct IdentifyProperties {
pub:
	os      string [json: '\$os']      = os.user_os()
	browser string [json: '\$browser'] = 'discord.v'
	device  string [json: '\$device']  = 'discord.v'
}
