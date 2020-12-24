module discordv

import time
import x.json2 as json
import discordv.util.snowflake

pub struct Attachment {
}

enum PermissionOverwriteType {
	role
	user
}

struct PermissionOverwrite {
pub mut:
	id    string
	@type PermissionOverwriteType
	allow string
	deny  string
}

pub fn (mut po PermissionOverwrite) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' { po.id = v.str() }
			'type' { po.@type = PermissionOverwriteType(v.int()) }
			'allow' { po.allow = v.str() }
			'deny' { po.deny = v.str() }
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
	id                    string
	@type                 ChannelType
	guild_id              string
	position              int
	permission_overwrites PermissionOverwrite
	name                  string
	topic                 string
	nsfw                  bool
	last_message_id       string
	bitrate               int
	user_limit            int
	rate_limit_per_user   int
	recipients            []User
	icon                  string
	owner_id              string
	application_id        string
	parent_id             string
	last_pin_timestamp    time.Time
}

pub fn (mut channel Channel) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' {
				channel.id = v.str()
			}
			'type' {
				channel.@type = ChannelType(v.int())
			}
			'guild_id' {
				channel.guild_id = v.str()
			}
			'position' {
				channel.position = v.int()
			}
			'permission_overwrites' {
				mut po := PermissionOverwrite{}
				po.from_json(v)
				channel.permission_overwrites = po
			}
			'name' {
				channel.name = v.str()
			}
			'topic' {
				channel.topic = v.str()
			}
			'nsfw' {
				channel.nsfw = v.bool()
			}
			'last_message_id' {
				channel.last_message_id = v.str()
			}
			'bitrate' {
				channel.bitrate = v.int()
			}
			'user_limit' {
				channel.user_limit = v.int()
			}
			'rate_limit_per_user' {
				channel.rate_limit_per_user = v.int()
			}
			'recipients' {
				mut obja := v.arr()
				for va in obja {
					mut user := User{}
					user.from_json(va)
					channel.recipients << user
				}
			}
			'icon' {
				channel.icon = v.str()
			}
			'owner_id' {
				channel.owner_id = v.str()
			}
			'application_id' {
				channel.application_id = v.str()
			}
			'parent_id' {
				channel.parent_id = v.str()
			}
			'last_pin_timestamp' {
				channel.last_pin_timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub struct Embed {
}

pub struct Emoji {
pub mut:
	id    string
	name  string
	roles []Role
}

pub fn (mut emoji Emoji) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' {
				emoji.id = v.str()
			}
			'name' {
				emoji.name = v.str()
			}
			'roles' {
				mut r_obj := v.arr()
				mut roles := []Role{}
				for r in r_obj {
					mut role := Role{}
					role.from_json(r)
					roles << role
				}
			}
			else {}
		}
	}
}

pub struct File {
pub mut:
	filename string
	data     []byte
}

pub struct UnavailableGuild {
pub mut:
	id          string
	unavailable bool
}

fn (mut g UnavailableGuild) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' { g.id = v.str() }
			'unavailable' { g.unavailable = v.bool() }
			else {}
		}
	}
}

pub struct Member {
}

pub struct Reaction {
pub mut:
	count int
	me    bool
	emoji Emoji
}

pub fn (mut r Reaction) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'count' {
				r.count = v.int()
			}
			'me' {
				r.me = v.bool()
			}
			'emoji' {
				mut emoji := Emoji{}
				emoji.from_json(v)
				r.emoji = emoji
			}
			else {}
		}
	}
}

pub struct Ready {
pub mut:
	v                int
	user             User
	private_channels []Channel
	guilds           []UnavailableGuild
	session_id       string
	shard            [2]int
}

pub fn (mut r Ready) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'v' {
				r.v = v.int()
			}
			'user' {
				mut user := User{}
				user.from_json(v)
				r.user = user
			}
			'private_channels' {
				mut channels := []Channel{}
				mut arr := v.arr()
				for g in arr {
					mut channel := Channel{}
					channel.from_json(g)
					channels << channel
				}
				r.private_channels = channels
			}
			'guilds' {
				mut guilds := []UnavailableGuild{}
				mut arr := v.arr()
				for g in arr {
					mut guild := UnavailableGuild{}
					guild.from_json(g)
					guilds << guild
				}
				r.guilds = guilds
			}
			'session_id' {
				r.session_id = v.str()
			}
			'shard' {
				mut shards := v.arr()
				r.shard[0] = shards[0].int()
				r.shard[1] = shards[1].int()
			}
			else {}
		}
	}
}

pub struct Role {
pub mut:
	id          string
	name        string
	color       int
	hoist       bool
	position    int
	permission  string
	managed     bool
	mentionable bool
}

pub fn (mut role Role) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' { role.id = v.str() }
			'name' { role.name = v.str() }
			'color' { role.color = v.int() }
			'hoist' { role.hoist = v.bool() }
			'position' { role.position = v.int() }
			'permission' { role.permission = v.str() }
			'managed' { role.managed = v.bool() }
			'mentionable' { role.mentionable = v.bool() }
			else {}
		}
	}
}

pub struct User {
pub mut:
	id            string
	username      string
	discriminator string
	avatar        Avatar
	bot           bool
	system        bool
	mfa_enabled   bool
	locale        string
	verified      bool
	email         string
	flags         UserFlag
	premium_type  PremiumType
	public_flags  UserFlag
}

pub struct Avatar {
	user_id string
pub:
	hash    string
}

pub fn (avatar Avatar) url() string {
	return 'https://cdn.discordapp.com/avatars/$avatar.user_id/{$avatar.hash}.png'
}

pub fn (avatar Avatar) str() string {
	return avatar.hash
}

pub type UserFlag = int

pub struct UserFlags {
pub:
	zero                         UserFlag = UserFlag(0)
	discord_employee             UserFlag = UserFlag(1 << 0)
	partnered_server_owner       UserFlag = UserFlag(1 << 1)
	hypersquad_events            UserFlag = UserFlag(1 << 2)
	bughunter_level1             UserFlag = UserFlag(1 << 3)
	house_bravery                UserFlag = UserFlag(1 << 6)
	house_brilliance             UserFlag = UserFlag(1 << 7)
	house_balance                UserFlag = UserFlag(1 << 8)
	early_supporter              UserFlag = UserFlag(1 << 9)
	team_user                    UserFlag = UserFlag(1 << 10)
	system                       UserFlag = UserFlag(1 << 12)
	bughunter_level2             UserFlag = UserFlag(1 << 14)
	verified_bot                 UserFlag = UserFlag(1 << 16)
	early_verified_bot_developer UserFlag = UserFlag(1 << 17)
}

pub const (
	user_flags = UserFlags{}
)

pub enum PremiumType {
	@none
	nitro_classic
	nitro
}

pub fn (mut user User) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' { user.id = v.str() }
			'username' { user.username = v.str() }
			'discriminator' { user.discriminator = v.str() }
			'bot' { user.bot = v.bool() }
			'system' { user.system = v.bool() }
			'mfa_enabled' { user.mfa_enabled = v.bool() }
			'locale' { user.locale = v.str() }
			'verified' { user.verified = v.bool() }
			'email' { user.email = v.str() }
			'flags' { user.flags = UserFlag(v.int()) }
			'premium_type' { user.premium_type = PremiumType(v.int()) }
			'public_flags' { user.public_flags = UserFlag(v.int()) }
			else {}
		}
	}
	if 'avatar' in obj {
		hash := obj['avatar'].str()
		user.avatar = Avatar{
			user_id: user.id
			hash: hash
		}
	}
}
