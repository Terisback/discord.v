module structs

import time
import x.json2 as json
import discordv.util.snowflake

// // Do we really need that level of abstraction?
// pub type Channel = TextChannel | DMChannel | VoiceChannel | DMGroupChannel | Category | NewsChannel | StoreChannel

enum PermissionOverwriteType{
	role
	user
}

struct PermissionOverwrite {
pub mut:
	id string
	@type PermissionOverwriteType
	allow string
	deny string
}

pub fn (mut po PermissionOverwrite) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {po.id = v.str()}
			'type' {po.@type = PermissionOverwriteType(v.int())}
			'allow' {po.allow = v.str()}
			'deny' {po.deny = v.str()}
			else {}
		}
	}
}

enum ChannelType {
	guild_text
	dm
	guild_voice
	group_dm
	guild_category
	guild_news
	guild_store
}

pub struct Channel {
pub mut:
	id string
	@type ChannelType
	guild_id string
	position int
	permission_overwrites PermissionOverwrite
	name string
	topic string
	nsfw bool
	last_message_id string
	bitrate int
	user_limit int
	rate_limit_per_user int
	recipients []User
	icon string
	owner_id string
	application_id string
	parent_id string
	last_pin_timestamp time.Time
}

pub fn (mut channel Channel) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {channel.id = v.str()}
			'type' {channel.@type = ChannelType(v.int())}
			'guild_id' {channel.guild_id = v.str()}
			'position' {channel.position = v.int()}
			'permission_overwrites' {
				mut po := PermissionOverwrite{}
				po.from_json(v)
				channel.permission_overwrites = po
			}
			'name' {channel.name = v.str()}
			'topic' {channel.topic = v.str()}
			'nsfw' {channel.nsfw = v.bool()}
			'last_message_id' {channel.last_message_id = v.str()}
			'bitrate' {channel.bitrate = v.int()}
			'user_limit' {channel.user_limit = v.int()}
			'rate_limit_per_user' {channel.rate_limit_per_user = v.int()}
			'recipients' {
				mut obja := v.arr()
				for va in obja{
					mut user := User{}
					user.from_json(va)
					channel.recipients << user
				}
			}
			'icon' {channel.icon = v.str()}
			'owner_id' {channel.owner_id = v.str()}
			'application_id' {channel.application_id = v.str()}
			'parent_id' {channel.parent_id = v.str()}
			'last_pin_timestamp' {channel.last_pin_timestamp = time.parse_iso8601(v.str()) or {
				time.unix(int(snowflake.discord_epoch / 1000))
			}}
			else {}
		}
	}
}

// pub struct TextChannel {
// 	id string
// 	guild_id string
// 	name string
// 	position int
// 	permission_overwrites []PermissionOverwrite
// 	rate_limit_per_user int
// 	nsfw bool
// 	topic string
// 	last_message_id string
// 	parent_id string
// }

// pub struct DMChannel {
// 	last_message_id string
// 	id string
// 	recipients []User
// }

// pub struct VoiceChannel {
// 	id string
// 	guild_id string
// 	name string
// 	nsfw bool
// 	position int
// 	permission_overwrites []PermissionOverwrite
// 	bitrate int
// 	user_limit int
// 	parent_id string
// }

// pub struct DMGroupChannel {
// 	name string
// 	icon string
// 	recipients []User
// 	last_message_id string
// 	id string
// 	owner_id string
// }

// pub struct Category {
// 	permission_overwrites []PermissionOverwrite
// 	name string
// 	parent_id string
// 	nsfw bool
// 	position int
// 	guild_id string
// 	id string
// }

// pub struct NewsChannel {
// 	id string
// 	guild_id string
// 	name string
// 	position int
// 	permission_overwrites []PermissionOverwrite
// 	nsfw bool
// 	topic string
// 	last_message_id string
// 	parent_id string
// }

// pub struct StoreChannel {
// 	id string
// 	guild_id string
// 	name string
// 	position int
// 	permission_overwrites []PermissionOverwrite
// 	nsfw bool
// 	parent_id string
// }
