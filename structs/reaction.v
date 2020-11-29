module structs

import x.json2 as json

pub struct Reaction {
pub mut:
	count int
	me bool
	emoji Emoji
}

pub fn (mut r Reaction) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'count' {r.count = v.int()}
			'me' {r.me = v.bool()}
			'emoji' {
				mut emoji := Emoji{}
				emoji.from_json(v)
				r.emoji = emoji
			}
			else {}
		}
	}
}