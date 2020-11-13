module discordv

import x.json2 as json

pub struct UnavailableGuild {
pub mut:
	id Snowflake
	unavailable bool
}

fn (mut g UnavailableGuild) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {g.id = new_snowflake(v.str().u64())}
			'unavailable' {g.unavailable = v.bool()}
			else {}
		}
	}
}