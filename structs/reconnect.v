module structs

import x.json2 as json

pub struct Reconnect {
pub mut:
	resumed bool
}

pub fn (mut r Reconnect) from_json(f json.Any) {
	mut obj := f.as_map()
	if 'resumed' in obj{
		r.resumed = obj['resumed'].bool()
	}
}