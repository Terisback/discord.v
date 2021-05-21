module packets

import os
import x.json2 as json

// Websocket Identify packet data
pub struct Identify {
pub:
	token      string
	properties IdentifyProperties = IdentifyProperties{}
	intents    int
	shard      []int
}

// Identify packet properies
pub struct IdentifyProperties {
pub:
	os      string = os.user_os()
	browser string = 'discord.v'
	device  string = 'discord.v'
}

pub fn (d Identify) to_json_any() json.Any {
	mut obj := map[string]json.Any{}
	obj['token'] = d.token
	obj['intents'] = d.intents
	if d.shard.len != 2 {
		mut shards := []json.Any{}
		shards << int(0)
		shards << int(1)
		obj['shard'] = shards
	} else {
		mut shards := []json.Any{}
		shards << d.shard[0]
		shards << d.shard[1]
		obj['shard'] = shards
	}
	mut prop := map[string]json.Any{}
	prop[r'$os'] = d.properties.os
	prop[r'$browser'] = d.properties.browser
	prop[r'$device'] = d.properties.device
	obj['properties'] = prop
	return obj
}
