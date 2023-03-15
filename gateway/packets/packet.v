module packets

import x.json2 as json

// Websocket Packet
pub struct Packet {
pub mut:
	op       Op
	sequence int
	event    string
	data     json.Any
}

pub fn (mut p Packet) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'op' { p.op = unsafe { Op(v.int()) } }
			's' { p.sequence = v.int() }
			't' { p.event = v.str() }
			'd' { p.data = v }
			else {}
		}
	}
}

pub fn (p Packet) to_json() string {
	mut obj := map[string]json.Any{}
	obj['op'] = int(p.op)
	obj['s'] = p.sequence
	obj['t'] = p.event
	obj['d'] = p.data
	return obj.str()
}

pub fn (p Packet) str() string {
	return p.to_json()
}
