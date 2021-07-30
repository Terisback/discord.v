module gateway

import json
import x.json2
import gateway.packets

// request_guild_members arguments
pub struct RequestGuildMembersArgs {
	guild_id  string
	query     string
	limit     int
	presences bool
	user_ids  []string
	nonce     string
}

pub fn (req RequestGuildMembersArgs) args() string {
	mut obj := map[string]json2.Any{}
	obj['guild_id'] = req.guild_id
	if req.user_ids.len != 0 {
		mut usr_ids := []json2.Any{}
		for usr in req.user_ids {
			usr_ids << usr
		}
		obj['user_ids'] = usr_ids
	} else {
		obj['query'] = req.query
	}
	obj['limit'] = req.limit
	obj['presences'] = req.presences
	obj['nonce'] = req.nonce
	return obj.str()
}

// Request guild members (It will wait answer from websocket)
pub fn (mut shard Shard) request_guild_members(args RequestGuildMembersArgs) {
	command := packets.Packet{
		op: .request_guild_members
		data: args.args()
	}
	shard.ws.write_string(json.encode(command)) or { panic(err) }
}

struct VoiceChannelJoinData {
	guild_id   string
	channel_id string
	self_mute  bool
	self_deaf  bool
}

// initiates a voice session to a voice channel, but does not complete it.
// if channel_id is empty, bot gonna disconnect from voice channel.
pub fn (mut shard Shard) channel_voice_join_manual(guild_id string, channel_id string, mute bool, deaf bool) ? {
	command := packets.Packet{
		op: .voice_state_update
		data: json.encode(VoiceChannelJoinData{
			guild_id: guild_id
			channel_id: channel_id
			self_mute: mute
			self_deaf: deaf
		})
	}
	shard.ws.write_string(json.encode(command)) ?
	shard.log.info('Connected to voice channel [guild_id: $guild_id, channel_id: $channel_id]')
}
