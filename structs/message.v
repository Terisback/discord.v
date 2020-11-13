module structs

import time
import x.json2 as json

pub struct Message {
pub mut:
	id string
	channel Channel
	author User
	member Member
	content string
	timestamp time.Time
	edited_timestamp time.Time
	tts bool
	mention_everyone bool
	mentions []User
	mention_roles []string
	mention_channels []string
	attachments []Attachment
	embeds []Embed
	reactions []Reaction
	nonce string
	pinned bool
	webhook_id string
	@type MessageType
	activity MessageActivity
	application MessageApplication
	message_reference MessageReference
	flags MessageFlags
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
}

pub enum MessageActivityType {
	join = 1
	spectate = 2
	listen = 3
	join_request = 5
}

pub struct MessageActivity {
pub mut:
	@type MessageActivityType
	party_id string
}

fn (mut m MessageActivity) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'type' {m.@type = MessageActivityType(v.int())}
			'party_id' {m.party_id = v.str()}
			else {}
		}
	}
}

pub struct MessageApplication {
pub mut:
	id string
	cover_image string
	description string
	icon string
	name string
}

fn (mut m MessageApplication) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {m.id = v.str()}
			'cover_image' {m.cover_image = v.str()}
			'description' {m.description = v.str()}
			'icon' {m.icon = v.str()}
			'name' {m.name = v.str()}
			else {}
		}
	}
}

// Contains reference data with crossposted messages
pub struct MessageReference {
pub mut:
	message_id string
	channel Channel
}


pub type MessageFlag = byte

pub struct MessageFlags {
pub:
	crossposted MessageFlag = MessageFlag(1 << 0)
	is_crosspost MessageFlag = MessageFlag(1 << 1)
	suppress_embeds MessageFlag = MessageFlag(1 << 2)
	source_message_deleted MessageFlag = MessageFlag(1 << 3)
	urgent MessageFlag = MessageFlag(1 << 4)
}

pub const (
	message_flags = MessageFlags{}
)

pub fn (mut m Message) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {m.id = v.str()}
			'content' {m.content = v.str()}
			'nonce' {m.nonce = v.str()}
			'activity' {
				mut activity := MessageActivity{}
				activity.from_json(v)
				m.activity = activity
			}
			else {}
		}
	}
}