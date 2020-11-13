module discordv

import x.json2 as json

pub struct Ready {
pub mut:
	v int
	// user User
	// private_channels []Channels
	guilds []UnavailableGuild
	session_id string
	shard [2]int
}

pub fn (mut r Ready) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'v' {r.v = v.int()}
			'guilds' {
				mut guilds := []UnavailableGuild{}
				mut arr := v.arr()
				for g in arr{
					mut guild := UnavailableGuild{}
					guild.from_json(g)
					guilds << guild
				}
				r.guilds = guilds
			}
			'session_id' {r.session_id = v.str()}
			'shard' {
				mut shards := v.arr()
				r.shard[0] = shards[0].int()
				r.shard[1] = shards[1].int()
			}
			else{}
		}
	}
}