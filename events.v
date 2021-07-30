module discordv

import time
import json
import x.json2
import gateway.packets
import snowflake

pub type Dispatch = packets.Packet
pub type Hello = packets.Hello
pub type ChannelCreate = Channel
pub type ChannelUpdate = Channel
pub type ChannelDelete = Channel

pub struct ChannelPinsUpdate {
pub mut:
	guild_id           string
	channel_id         string
	last_pin_timestamp time.Time
}

pub fn (mut cpu ChannelPinsUpdate) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
			'last_pin_timestamp' {
				cpu.last_pin_timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub type GuildCreate = Guild
pub type GuildUpdate = Guild
pub type GuildDelete = UnavailableGuild

struct GuildBan {
pub mut:
	guild_id string
	user     User
}

pub type GuildBanAdd = GuildBan
pub type GuildBanRemove = GuildBan

pub struct GuildEmojisUpdate {
pub mut:
	guild_id string
	emojis   []Emoji
}

pub struct GuildIntegrationsUpdate {
pub mut:
	guild_id string
}

pub struct GuildMemberAdd {
pub mut:
	guild_id string
	member   Member
}

pub struct GuildMemberRemove {
pub mut:
	guild_id string
	user     User
}

pub struct GuildMemberUpdate {
pub mut:
	guild_id      string
	roles         []string
	user          User
	nick          string
	joined_at     time.Time
	premium_since time.Time
}

pub fn (mut gmu GuildMemberUpdate) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
			'joined_at' {
				gmu.joined_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'premium_since' {
				gmu.premium_since = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub struct GuildMembersChunk {
pub mut:
	guild_id    string
	members     []Member
	chunk_index int
	chunk_count int
	not_found   []string
	presences   []PresenceUpdate
	nonce       string
}

struct GuildRole {
pub mut:
	guild_id string
	role     Role
}

pub type GuildRoleCreate = GuildRole
pub type GuildRoleUpdate = GuildRole

pub struct GuildRoleDelete {
pub mut:
	guild_id string
	role_id  string
}

pub struct InviteCreate {
pub mut:
	channel_id  string
	code        string
	created_at  time.Time
	guild_id    string
	inviter     User
	max_age     int
	max_uses    int
	target_user User
	temporary   bool
	uses        int
}

pub fn (mut ic InviteCreate) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	mmm := obj.as_map()
	if 'created_at' in mmm {
		ic.created_at = time.parse_iso8601(mmm['created_at'].str()) or {
			time.unix(int(snowflake.discord_epoch / 1000))
		}
	}
}

pub struct InviteDelete {
pub mut:
	channel_id string
	guild_id   string
	code       string
}

pub type MessageCreate = Message
pub type MessageUpdate = Message
pub type MessageDelete = Message

pub struct MessageDeleteBulk {
pub mut:
	ids        []string
	channel_id string
	guild_id   string
}

pub struct MessageReactionAdd {
pub mut:
	user_id    string
	channel_id string
	message_id string
	guild_id   string
	member     Member
	emoji      Emoji
}

pub struct MessageReactionRemove {
pub mut:
	user_id    string
	channel_id string
	message_id string
	guild_id   string
	emoji      Emoji
}

pub struct MessageReactionRemoveAll {
pub mut:
	channel_id string
	message_id string
	guild_id   string
}

pub struct MessageReactionRemoveEmoji {
pub mut:
	channel_id string
	message_id string
	guild_id   string
	emoji      Emoji
}

pub struct TypingStart {
pub mut:
	channel_id string
	guild_id   string
	user_id    string
	timestamp  int
	member     Member
}

pub type UserUpdate = User
pub type VoiceStateUpdate = VoiceState

pub struct VoiceServerUpdate {
pub mut:
	token    string
	guild_id string
	endpoint string
}

pub struct WebhooksUpdate {
pub mut:
	guild_id   string
	channel_id string
}

pub type InteractionCreate = Interaction

// Publishing hello event to client eventbus
fn on_hello(mut client Client, hello &packets.Hello) {
	client.events.publish('hello', client, hello)
}

// Deals with packets from gateway. Publishing to client eventbus
fn on_dispatch(mut client Client, packet &packets.Packet) {
	event_name := packet.event.to_lower()
	data := packet.data
	client.events.publish('dispatch', client, packet)
	match event_name {
		'ready' {
			obj := json.decode(Ready, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'channel_create' {
			obj := json.decode(ChannelCreate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'channel_update' {
			obj := json.decode(ChannelUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'channel_delete' {
			obj := json.decode(ChannelDelete, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'channel_pins_update' {
			mut obj := json.decode(ChannelPinsUpdate, data) or { return }
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_create' {
			obj := json.decode(GuildCreate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_update' {
			obj := json.decode(GuildUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_delete' {
			obj := json.decode(GuildDelete, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_ban_add' {
			obj := json.decode(GuildBanAdd, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_ban_remove' {
			obj := json.decode(GuildBanRemove, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_emojis_update' {
			obj := json.decode(GuildEmojisUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_integrations_update' {
			obj := json.decode(GuildIntegrationsUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_member_add' {
			obj := json.decode(GuildMemberAdd, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_member_remove' {
			obj := json.decode(GuildMemberRemove, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_member_update' {
			mut obj := json.decode(GuildMemberUpdate, data) or { return }
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_members_chunk' {
			// TODO: Handle by nonce, return to rest
		}
		'guild_role_create' {
			obj := json.decode(GuildRoleCreate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_role_update' {
			obj := json.decode(GuildRoleUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'guild_role_delete' {
			obj := json.decode(GuildRoleDelete, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'invite_create' {
			mut obj := json.decode(InviteCreate, data) or { return }
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'invite_delete' {
			obj := json.decode(InviteDelete, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_create' {
			obj := json.decode(MessageCreate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_update' {
			obj := json.decode(MessageUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_delete' {
			obj := json.decode(MessageDelete, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_delete_bulk' {
			obj := json.decode(MessageDeleteBulk, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_add' {
			obj := json.decode(MessageReactionAdd, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_remove' {
			obj := json.decode(MessageReactionRemove, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_remove_all' {
			obj := json.decode(MessageReactionRemoveAll, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_remove_emoji' {
			obj := json.decode(MessageReactionRemoveEmoji, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'presence_update' {
			obj := json.decode(PresenceUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'typing_start' {
			obj := json.decode(TypingStart, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'user_update' {
			obj := json.decode(UserUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'voice_state_update' {
			obj := json.decode(VoiceStateUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'voice_server_update' {
			obj := json.decode(VoiceServerUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'webhooks_update' {
			obj := json.decode(WebhooksUpdate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		'interaction_create' {
			obj := json.decode(InteractionCreate, data) or { return }
			client.events.publish(event_name, client, obj)
		}
		else {
			client.log.info('Unhandled event: $event_name')
		}
	}
}

// Add event handler to Dispatch event
pub fn (mut client Client) on_dispatch(handler fn (mut Client, &Dispatch)) {
	client.events.subscribe('dispatch', handler)
}

// Add event handler to Hello event
pub fn (mut client Client) on_hello(handler fn (mut Client, &Hello)) {
	client.events.subscribe('hello', handler)
}

// Add event handler to Ready event
pub fn (mut client Client) on_ready(handler fn (mut Client, &Ready)) {
	client.events.subscribe('ready', handler)
}

// Add event handler to ChannelCreate event
pub fn (mut client Client) on_channel_create(handler fn (mut Client, &ChannelCreate)) {
	client.events.subscribe('channel_create', handler)
}

// Add event handler to ChannelUpdate event
pub fn (mut client Client) on_channel_update(handler fn (mut Client, &ChannelUpdate)) {
	client.events.subscribe('channel_update', handler)
}

// Add event handler to ChannelDelete event
pub fn (mut client Client) on_channel_delete(handler fn (mut Client, &ChannelDelete)) {
	client.events.subscribe('channel_delete', handler)
}

// Add event handler to ChannelPinsUpdate event
pub fn (mut client Client) on_channel_pins_update(handler fn (mut Client, &ChannelPinsUpdate)) {
	client.events.subscribe('channel_pins_update', handler)
}

// Add event handler to GuildCreate event
pub fn (mut client Client) on_guild_create(handler fn (mut Client, &GuildCreate)) {
	client.events.subscribe('guild_create', handler)
}

// Add event handler to GuildUpdate event
pub fn (mut client Client) on_guild_update(handler fn (mut Client, &GuildUpdate)) {
	client.events.subscribe('guild_create', handler)
}

// Add event handler to GuildDelete event
pub fn (mut client Client) on_guild_delete(handler fn (mut Client, &GuildDelete)) {
	client.events.subscribe('guild_create', handler)
}

// Add event handler to GuildBanAdd event
pub fn (mut client Client) on_guild_ban_add(handler fn (mut Client, &GuildBanAdd)) {
	client.events.subscribe('guild_ban_add', handler)
}

// Add event handler to GuildBanRemove event
pub fn (mut client Client) on_guild_ban_remove(handler fn (mut Client, &GuildBanRemove)) {
	client.events.subscribe('guild_ban_remove', handler)
}

// Add event handler to GuildEmojisUpdate event
pub fn (mut client Client) on_guild_emojis_update(handler fn (mut Client, &GuildEmojisUpdate)) {
	client.events.subscribe('guild_emojis_update', handler)
}

// Add event handler to GuildIntegrationsUpdate event
pub fn (mut client Client) on_guild_integrations_update(handler fn (mut Client, &GuildIntegrationsUpdate)) {
	client.events.subscribe('guild_integrations_update', handler)
}

// Add event handler to GuildMemberAdd event
pub fn (mut client Client) on_guild_member_add(handler fn (mut Client, &GuildMemberAdd)) {
	client.events.subscribe('guild_member_add', handler)
}

// Add event handler to GuildMemberRemove event
pub fn (mut client Client) on_guild_member_remove(handler fn (mut Client, &GuildMemberRemove)) {
	client.events.subscribe('guild_member_remove', handler)
}

// Add event handler to GuildMemberUpdate event
pub fn (mut client Client) on_guild_member_update(handler fn (mut Client, &GuildMemberUpdate)) {
	client.events.subscribe('guild_member_update', handler)
}

// Add event handler to GuildRoleCreate event
pub fn (mut client Client) on_guild_role_create(handler fn (mut Client, &GuildRoleCreate)) {
	client.events.subscribe('guild_role_create', handler)
}

// Add event handler to GuildRoleUpdate event
pub fn (mut client Client) on_guild_role_update(handler fn (mut Client, &GuildRoleUpdate)) {
	client.events.subscribe('guild_role_update', handler)
}

// Add event handler to GuildRoleDelete event
pub fn (mut client Client) on_guild_role_delete(handler fn (mut Client, &GuildRoleDelete)) {
	client.events.subscribe('guild_role_delete', handler)
}

// Add event handler to InviteCreate event
pub fn (mut client Client) on_invite_create(handler fn (mut Client, &InviteCreate)) {
	client.events.subscribe('invite_create', handler)
}

// Add event handler to InviteDelete event
pub fn (mut client Client) on_invite_delete(handler fn (mut Client, &InviteDelete)) {
	client.events.subscribe('invite_delete', handler)
}

// Add event handler to MessageCreate event
pub fn (mut client Client) on_message_create(handler fn (mut Client, &MessageCreate)) {
	client.events.subscribe('message_create', handler)
}

// Add event handler to MessageUpdate event
pub fn (mut client Client) on_message_update(handler fn (mut Client, &MessageUpdate)) {
	client.events.subscribe('message_update', handler)
}

// Add event handler to MessageDelete event
pub fn (mut client Client) on_message_delete(handler fn (mut Client, &MessageDelete)) {
	client.events.subscribe('message_delete', handler)
}

// Add event handler to MessageDeleteBulk event
pub fn (mut client Client) on_message_delete_bulk(handler fn (mut Client, &MessageDeleteBulk)) {
	client.events.subscribe('message_delete_bulk', handler)
}

// Add event handler to MessageReactionAdd event
pub fn (mut client Client) on_message_reaction_add(handler fn (mut Client, &MessageReactionAdd)) {
	client.events.subscribe('message_reaction_add', handler)
}

// Add event handler to MessageReactionRemove event
pub fn (mut client Client) on_message_reaction_remove(handler fn (mut Client, &MessageReactionRemove)) {
	client.events.subscribe('message_reaction_remove', handler)
}

// Add event handler to MessageReactionRemoveAll event
pub fn (mut client Client) on_message_reaction_remove_all(handler fn (mut Client, &MessageReactionRemoveAll)) {
	client.events.subscribe('message_reaction_remove_all', handler)
}

// Add event handler to MessageReactionRemoveEmoji event
pub fn (mut client Client) on_message_reaction_remove_emoji(handler fn (mut Client, &MessageReactionRemoveEmoji)) {
	client.events.subscribe('message_reaction_remove_emoji', handler)
}

// Add event handler to PresenceUpdate event
pub fn (mut client Client) on_presence_update(handler fn (mut Client, &PresenceUpdate)) {
	client.events.subscribe('presence_update', handler)
}

// Add event handler to TypingStart event
pub fn (mut client Client) on_typing_start(handler fn (mut Client, &TypingStart)) {
	client.events.subscribe('typing_start', handler)
}

// Add event handler to UserUpdate event
pub fn (mut client Client) on_user_update(handler fn (mut Client, &UserUpdate)) {
	client.events.subscribe('user_update', handler)
}

// Add event handler to VoiceStateUpdate event
pub fn (mut client Client) on_voice_state_update(handler fn (mut Client, &VoiceStateUpdate)) {
	client.events.subscribe('voice_state_update', handler)
}

// Add event handler to VoiceServerUpdate event
pub fn (mut client Client) on_voice_server_update(handler fn (mut Client, &VoiceServerUpdate)) {
	client.events.subscribe('voice_server_update', handler)
}

// Add event handler to WebhooksUpdate event
pub fn (mut client Client) on_webhooks_update(handler fn (mut Client, &WebhooksUpdate)) {
	client.events.subscribe('webhooks_update', handler)
}

// Add event handler to InteractionCreate event
pub fn (mut client Client) on_interaction_create(handler fn (mut Client, &InteractionCreate)) {
	client.events.subscribe('interaction_create', handler)
}
