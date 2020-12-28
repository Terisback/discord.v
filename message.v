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
	mention_channels  []ChannelMention
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
	referenced_message &Message = voidptr(0)
	stickers []Sticker
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

pub fn (mut m MessageReference) from_json(f json.Any) {
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

pub fn (m MessageReference) to_json() json.Any{
	mut obj := map[string]json.Any{}
	obj['message_id'] = m.message_id
	obj['channel_id'] = m.channel_id
	obj['guild_id'] = m.guild_id
	return obj
}

pub enum StickerType {
	png = 1
	apng
	lottie
}

pub struct Sticker {
pub mut:
	id string
	pack_id string
	name string
	description string
	tags string
	asset string
	preview_asset string
	format_type StickerType
}

pub fn (mut st Sticker) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {st.id = v.str()}
			'pack_id' {st.pack_id = v.str()}
			'name' {st.name = v.str()}
			'description' {st.description = v.str()}
			'tags' {st.tags = v.str()}
			'asset' {st.asset = v.str()}
			'preview_asset' {st.preview_asset = v.str()}
			'format_type' {st.format_type = StickerType(v.int())}
			else {}
		}
	}
}

pub type MessageFlag = byte

pub const (
	crossposted            = MessageFlag(1 << 0)
	is_crosspost           = MessageFlag(1 << 1)
	suppress_embeds        = MessageFlag(1 << 2)
	source_message_deleted = MessageFlag(1 << 3)
	urgent                 = MessageFlag(1 << 4)
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
			'member' {
				mut member := Member{}
				member.from_json(v)
				m.member = member
			}
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
				for _, va in obja {
					mut mention := ChannelMention{}
					mention.from_json(va)
					m.mention_channels << mention
				}
			}
			'attachments' {
				mut obja := v.arr()
				for _, va in obja {
					mut attachment := Attachment{}
					attachment.from_json(va)
					m.attachments << attachment
				}
			}
			'embeds' {
				mut obja := []Embed{}
				obja.from_json(v)
				m.embeds = obja
			}
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
			'referenced_message' {
				mut ref := Message{}
				ref.from_json(v)
				m.referenced_message = &ref
			}
			'stickers' {
				mut obja := v.arr()
				for _, va in obja {
					mut sticker := Sticker{}
					sticker.from_json(va)
					m.stickers << sticker
				}
			}
			'flags' {
				m.flags = MessageFlag(byte(v.int()))
			}
			else {}
		}
	}
}

pub fn (m Message) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['content'] = m.content
	obj['nonce'] = m.nonce
	obj['tts'] = m.tts
	if m.embeds.len >= 1 {
		obj['embed'] = m.embeds[0].to_json()
	}
	if m.message_reference.message_id != '' {
		obj['message_reference'] = m.message_reference.to_json()
	}
	return obj
}