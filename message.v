module discordv

import x.json2 as json
import time

pub struct Message {
pub mut:
	id                string
	channel_id        string
	guild_id          string
	author            User
	member            Member
	content           string
	timestamp         time.Time
	edited_timestamp  time.Time
	tts               bool
	mention_everyone  bool
	mentions          []User
	mention_roles     []string
	mention_channels  []string
	attachments       []Attachment
	embeds            []Embed
	reactions         []Reaction
	nonce             string
	pinned            bool
	webhook_id        string
	@type             MessageType
	activity          MessageActivity
	application       MessageApplication
	message_reference MessageReference
	flags             MessageFlag
}

pub enum MessageType {
	default
	recipient_add
	recipient_remove
	call
	channel_name_change
	channel_icon_change
	channel_pinned_message
	guild_member_join
	user_premium_guild_subscription
	user_premium_guild_subscription_tier_1
	user_premium_guild_subscription_tier_2
	user_premium_guild_subscription_tier_3
	channel_follow_add
	guild_discovery_disqualified
	guild_discovery_requalified
	reply = 19
	application_command
}

pub enum MessageActivityType {
	join = 1
	spectate = 2
	listen = 3
	join_request = 5
}

pub struct MessageActivity {
pub mut:
	@type    MessageActivityType
	party_id string
}

fn (mut m MessageActivity) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'type' { m.@type = MessageActivityType(v.int()) }
			'party_id' { m.party_id = v.str() }
			else {}
		}
	}
}

pub struct MessageApplication {
pub mut:
	id          string
	cover_image string
	description string
	icon        string
	name        string
}

fn (mut m MessageApplication) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' { m.id = v.str() }
			'cover_image' { m.cover_image = v.str() }
			'description' { m.description = v.str() }
			'icon' { m.icon = v.str() }
			'name' { m.name = v.str() }
			else {}
		}
	}
}

// Contains reference data with crossposted messages
pub struct MessageReference {
pub mut:
	message_id string
	channel_id string
	guild_id   string
}

fn (mut m MessageReference) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'message_id' { m.message_id = v.str() }
			'channel_id' { m.channel_id = v.str() }
			'guild_id' { m.guild_id = v.str() }
			else {}
		}
	}
}

pub type MessageFlag = byte

pub struct MessageFlags {
pub:
	crossposted            MessageFlag = MessageFlag(1 << 0)
	is_crosspost           MessageFlag = MessageFlag(1 << 1)
	suppress_embeds        MessageFlag = MessageFlag(1 << 2)
	source_message_deleted MessageFlag = MessageFlag(1 << 3)
	urgent                 MessageFlag = MessageFlag(1 << 4)
}

pub const (
	message_flags = MessageFlags{}
)

pub fn (mut m Message) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'id' {
				m.id = v.str()
			}
			'channel_id' {
				m.channel_id = v.str()
			}
			'guild_id' {
				m.guild_id = v.str()
			}
			'author' {
				mut user := User{}
				user.from_json(v)
				m.author = user
			}
			//'member' {}
			'content' {
				m.content = v.str()
			}
			'timestamp' {
				m.timestamp = time.parse_iso8601(v.str()) or { time.unix(0) }
			}
			'edited_timestamp' {
				m.edited_timestamp = time.parse_iso8601(v.str()) or { time.unix(0) }
			}
			'tts' {
				m.tts = v.bool()
			}
			'mention_everyone' {
				m.mention_everyone = v.bool()
			}
			'mentions' {
				mut obja := v.arr()
				for va in obja {
					mut user := User{}
					user.from_json(va)
					m.mentions << user
				}
			}
			'mention_roles' {
				mut obja := v.arr()
				for va in obja {
					m.mention_roles << va.str()
				}
			}
			'mention_channels' {
				mut obja := v.arr()
				for va in obja {
					m.mention_channels << va.str()
				}
			}
			//'attachments' {}
			//'embeds' {}
			'reaction' {
				mut obja := v.arr()
				for _, va in obja {
					mut reaction := Reaction{}
					reaction.from_json(va)
					m.reactions << reaction
				}
			}
			'nonce' {
				m.nonce = v.str()
			}
			'pinned' {
				m.pinned = v.bool()
			}
			'webhook_id' {
				m.webhook_id = v.str()
			}
			'type' {
				m.@type = MessageType(v.int())
			}
			'activity' {
				mut activity := MessageActivity{}
				activity.from_json(v)
				m.activity = activity
			}
			'application' {
				mut application := MessageApplication{}
				application.from_json(v)
				m.application = application
			}
			'message_reference' {
				mut reference := MessageReference{}
				reference.from_json(v)
				m.message_reference = reference
			}
			'flags' {
				m.flags = MessageFlag(byte(v.int()))
			}
			else {}
		}
	}
}

pub fn (m Message) outbound_json() string {
	mut obj := map[string]json.Any{}
	obj['content'] = m.content
	obj['nonce'] = m.nonce
	obj['tts'] = m.tts
	// if m.embeds.len >= 1 {
	// 	obj['embed'] = m.embeds[0]
	// }
	// obj['message_refence'] = m.message_reference
	return obj.str()
}
