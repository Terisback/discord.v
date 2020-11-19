module gateway

import os
import term
import x.json2 as json
import discordv
import discordv.util

pub struct Packet {
pub mut:
	op int
	sequence int
	event string
	data json.Any
}

pub fn (mut p Packet) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'op' {p.op = v.int()}
			's' {p.sequence = v.int()}
			't' {p.event = v.str()}
			'd' {p.data = v}
			else {}
		}
	}
}

pub fn (p Packet) to_json() string {
	mut obj := map[string]json.Any
	obj['op'] = p.op
	obj['s'] = p.sequence
	obj['t'] = p.event
	obj['d'] = p.data
	return obj.str()
}

pub fn (p Packet) str() string{
	return p.to_json()
}

struct Identify {
	token string
	properties IdentifyProperties = IdentifyProperties{}
	intents discordv.Intent
	shard []int
}

struct IdentifyProperties {
	os string = os.user_os()
	browser string = 'discord.v'
	device string = 'discord.v'
}

pub fn (d Identify) to_json_any() json.Any{
	mut obj := map[string]json.Any
	obj['token'] = d.token
	obj['intents'] = int(d.intents)

	if d.shard.len != 2{
		util.log(term.bright_red('you fool, why your shard array isn\'n valid?!'))
		mut shards := []json.Any{}
		shards << 0
		shards << 1
		obj['shard'] = shards
	} else {
		mut shards := []json.Any{}
		shards << d.shard[0]
		shards << d.shard[1]
		obj['shard'] = shards
	}

	mut prop := map[string]json.Any
	prop[r'$os'] = d.properties.os
	prop[r'$browser'] = d.properties.browser
	prop[r'$device'] = d.properties.device

	obj['properties'] = prop
	return obj
}

struct Resume {
	token string
	session_id string
	sequence int
}

pub fn (d Resume) to_json_any() json.Any{
	mut resume := map[string]json.Any
	resume['token'] = d.token
	resume['session_id'] = d.session_id
	resume['seq'] = d.sequence
	return resume
}