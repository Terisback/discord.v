module discordv

import os
import x.json2 as json

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
	intents Intent
}

struct IdentifyProperties {
	os string = os.user_os()
	browser string = 'discord.v'
	device string = 'discord.v'
}

pub fn (p IdentifyPacket) to_json() string{
	mut pack := map[string]json.Any
	pack['op'] = 2 // Identify op code

	mut obj := map[string]json.Any
	obj['token'] = p.d.token
	obj['intents'] = int(p.d.intents)

	mut prop := map[string]json.Any
	prop[r'$os'] = p.d.properties.os
	prop[r'$browser'] = p.d.properties.browser
	prop[r'$device'] = p.d.properties.device

	obj['properties'] = prop

	pack['d'] = obj
	return pack.str()
}

struct HelloPacket {
mut:
	heartbeat_interval u64
}

pub fn (mut p HelloPacket) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'heartbeat_interval' {p.heartbeat_interval = u64(v.f64())}
			else{}
		}
	}
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