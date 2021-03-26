module gateway

import x.json2 as json
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

pub fn (req RequestGuildMembersArgs) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['guild_id'] = req.guild_id
	if req.user_ids.len != 0 {
		mut usr_ids := []json.Any{}
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
	return obj
}

// Request guild members (It will wait answer from websocket)
pub fn (mut shard Shard) request_guild_members(args RequestGuildMembersArgs) {
	mut command := packets.Packet{
		op: .request_guild_members
		data: args.to_json()
	}.str()
	shard.ws.write_string(command) or { panic(err) }
}
