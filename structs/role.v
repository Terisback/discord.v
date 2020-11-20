module structs

import x.json2 as json

pub struct Role {
pub mut:
	id string
	name string
	color int
	hoist bool
	position int
	permission string
	managed bool
	mentionable bool
}

pub fn (mut role Role) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {role.id = v.str()}
			'name' {role.name = v.str()}
			'color' {role.color = v.int()}
			'hoist' {role.hoist = v.bool()}
			'position' {role.position = v.int()}
			'permission' {role.permission = v.str()}
			'managed' {role.managed = v.bool()}
			'mentionable' {role.mentionable = v.bool()}
			else{}
		}
	}
}