module discordv

import x.json2 as json

pub struct Ready {
pub mut:
	v int
	// user User
	// private_channels []Channels
	// guilds []UnavailableHuild
	session_id string
	// shard [2]int
}

pub fn (mut r Ready) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'v' {r.v = v.int()}
			'session_id' {r.session_id = v.str()}
			else{}
		}
	}
}

pub fn (r Ready) to_json() string{
	mut obj := map[string]json.Any
	obj['v'] = r.v
	obj['session_id'] = r.session_id
	return obj.str()
}