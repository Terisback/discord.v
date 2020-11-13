module client

import os
import x.json2 as json
import discordv

enum Op {
	dispatch
	heartbeat
	identify
	presence_update
	voice_state_update
	five_undocumented
	resume
	reconnect
	request_guild_members
	invalid_session
	hello
	heartbeat_ack
}

struct GatewayPacket {
mut:
	op int
	sequence int
	event string
	data json.Any
}

pub fn (mut p GatewayPacket) from_json(f json.Any){
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

struct IdentifyPacket {
	op int
	d Identify
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

pub fn (p IdentifyPacket) to_json() string{
	mut pack := map[string]json.Any
	pack['op'] = int(Op.identify)

	mut obj := map[string]json.Any
	obj['token'] = p.d.token
	obj['intents'] = int(p.d.intents)

	if p.d.shard.len != 2{
		log('you fool, why your shard array isn\'n valid?!')
		mut shards := []json.Any{}
		shards << 0
		shards << 1
		obj['shard'] = shards
	} else {
		mut shards := []json.Any{}
		shards << p.d.shard[0]
		shards << p.d.shard[1]
		obj['shard'] = shards
	}

	mut prop := map[string]json.Any
	prop[r'$os'] = p.d.properties.os
	prop[r'$browser'] = p.d.properties.browser
	prop[r'$device'] = p.d.properties.device

	obj['properties'] = prop

	pack['d'] = obj
	return pack.str()
}

struct HeartbeatPacket{
	op int
	data int
}

pub fn (p HeartbeatPacket) to_json() string{
	mut obj := map[string]json.Any
	obj['op'] = p.op
	obj['d'] = p.data
	return obj.str()
}

struct ResumePacket{
	op int
	data Resume
}

struct Resume {
	token string
	session_id string
	sequence int
}

pub fn (p ResumePacket) to_json() string{
	mut obj := map[string]json.Any
	obj['op'] = p.op

	mut resume := map[string]json.Any
	resume['token'] = p.data.token
	resume['session_id'] = p.data.session_id
	resume['seq'] = p.data.sequence

	obj['d'] = resume
	return obj.str()
}