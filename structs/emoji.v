module structs

import x.json2 as json

pub struct Emoji {
pub mut:
	id string
	name string
	roles []Role
}

pub fn (mut emoji Emoji) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {emoji.id = v.str()}
			'name' {emoji.name = v.str()}
			'roles' {
				mut r_obj := v.arr()
				mut roles := []Role{}
				for r in r_obj{
					mut role := Role{}
					role.from_json(r)
					roles << role
				}
			}
			else {}
		}
	}
}