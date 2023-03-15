module discordv

import time
import x.json2 as json
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

pub fn (mut cpu ChannelPinsUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				cpu.guild_id = v.str()
			}
			'channel_id' {
				cpu.channel_id = v.str()
			}
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

pub fn (mut gb GuildBan) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				gb.guild_id = v.str()
			}
			'user' {
				gb.user = from_json[User](v.as_map())
			}
			else {}
		}
	}
}

pub type GuildBanAdd = GuildBan
pub type GuildBanRemove = GuildBan

pub struct GuildEmojisUpdate {
pub mut:
	guild_id string
	emojis   []Emoji
}

pub fn (mut geu GuildEmojisUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				geu.guild_id = v.str()
			}
			'emojis' {
				geu.emojis = from_json_arr[Emoji](v.arr())
			}
			else {}
		}
	}
}

pub struct GuildIntegrationsUpdate {
pub mut:
	guild_id string
}

pub fn (mut geu GuildIntegrationsUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				geu.guild_id = v.str()
			}
			else {}
		}
	}
}

pub struct GuildMemberAdd {
pub mut:
	guild_id string
	member   Member
}

pub fn (mut gma GuildMemberAdd) from_json(f map[string]json.Any) {
	if guild_id := f['guild_id'] {
		gma.guild_id = guild_id.str()
	}
	gma.member.from_json(f)
}

pub struct GuildMemberRemove {
pub mut:
	guild_id string
	user     User
}

pub fn (mut gmr GuildMemberRemove) from_json(f map[string]json.Any) {
	if guild_id := f['guild_id'] {
		gmr.guild_id = guild_id.str()
	}
	if user := f['user'] {
		gmr.user.from_json(user.as_map())
	}
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

pub fn (mut gmu GuildMemberUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				gmu.guild_id = v.str()
			}
			'roles' {
				mut roles := v.arr()
				for role in roles {
					gmu.roles << role.str()
				}
			}
			'user' {
				gmu.user = from_json[User](v.as_map())
			}
			'nick' {
				gmu.nick = v.str()
			}
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

pub fn (mut gmc GuildMembersChunk) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				gmc.guild_id = v.str()
			}
			'members' {
				gmc.members = from_json_arr[Member](v.arr())
			}
			'chunk_index' {
				gmc.chunk_index = v.int()
			}
			'chunk_count' {
				gmc.chunk_count = v.int()
			}
			'not_found' {
				mut ids := v.arr()
				for id in ids {
					gmc.not_found << id.str()
				}
			}
			'presences' {
				gmc.presences = from_json_arr[PresenceUpdate](v.arr())
			}
			'nonce' {
				gmc.nonce = v.str()
			}
			else {}
		}
	}
}

struct GuildRole {
pub mut:
	guild_id string
	role     Role
}

pub fn (mut gr GuildRole) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				gr.guild_id = v.str()
			}
			'role' {
				gr.role = from_json[Role](v.as_map())
			}
			else {}
		}
	}
}

pub type GuildRoleCreate = GuildRole
pub type GuildRoleUpdate = GuildRole

pub struct GuildRoleDelete {
pub mut:
	guild_id string
	role_id  string
}

pub fn (mut grd GuildRoleDelete) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				grd.guild_id = v.str()
			}
			'role_id' {
				grd.role_id = v.str()
			}
			else {}
		}
	}
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

pub fn (mut ic InviteCreate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'channel_id' {
				ic.channel_id = v.str()
			}
			'code' {
				ic.code = v.str()
			}
			'created_at' {
				ic.created_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'guild_id' {
				ic.guild_id = v.str()
			}
			'inviter' {
				ic.inviter = from_json[User](v.as_map())
			}
			'max_age' {
				ic.max_age = v.int()
			}
			'max_uses' {
				ic.max_uses = v.int()
			}
			'target_user' {
				ic.target_user = from_json[User](v.as_map())
			}
			'temporary' {
				ic.temporary = v.bool()
			}
			'uses' {
				ic.uses = v.int()
			}
			else {}
		}
	}
}

pub struct InviteDelete {
pub mut:
	channel_id string
	guild_id   string
	code       string
}

pub fn (mut id InviteDelete) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'channel_id' {
				id.channel_id = v.str()
			}
			'guild_id' {
				id.guild_id = v.str()
			}
			'code' {
				id.code = v.str()
			}
			else {}
		}
	}
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

pub fn (mut mdb MessageDeleteBulk) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'ids' {
				mut ids := v.arr()
				for id in ids {
					mdb.ids << id.str()
				}
			}
			'channel_id' {
				mdb.channel_id = v.str()
			}
			'guild_id' {
				mdb.guild_id = v.str()
			}
			else {}
		}
	}
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

pub fn (mut mra MessageReactionAdd) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'user_id' {
				mra.user_id = v.str()
			}
			'channel_id' {
				mra.channel_id = v.str()
			}
			'message_id' {
				mra.message_id = v.str()
			}
			'guild_id' {
				mra.guild_id = v.str()
			}
			'member' {
				mra.member = from_json[Member](v.as_map())
			}
			'emoji' {
				mra.emoji = from_json[Emoji](v.as_map())
			}
			else {}
		}
	}
}

pub struct MessageReactionRemove {
pub mut:
	user_id    string
	channel_id string
	message_id string
	guild_id   string
	emoji      Emoji
}

pub fn (mut mra MessageReactionRemove) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'user_id' {
				mra.user_id = v.str()
			}
			'channel_id' {
				mra.channel_id = v.str()
			}
			'message_id' {
				mra.message_id = v.str()
			}
			'guild_id' {
				mra.guild_id = v.str()
			}
			'emoji' {
				mra.emoji = from_json[Emoji](v.as_map())
			}
			else {}
		}
	}
}

pub struct MessageReactionRemoveAll {
pub mut:
	channel_id string
	message_id string
	guild_id   string
}

pub fn (mut mra MessageReactionRemoveAll) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'channel_id' {
				mra.channel_id = v.str()
			}
			'message_id' {
				mra.message_id = v.str()
			}
			'guild_id' {
				mra.guild_id = v.str()
			}
			else {}
		}
	}
}

pub struct MessageReactionRemoveEmoji {
pub mut:
	channel_id string
	message_id string
	guild_id   string
	emoji      Emoji
}

pub fn (mut mra MessageReactionRemoveEmoji) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'channel_id' {
				mra.channel_id = v.str()
			}
			'message_id' {
				mra.message_id = v.str()
			}
			'guild_id' {
				mra.guild_id = v.str()
			}
			'emoji' {
				mra.emoji = from_json[Emoji](v.as_map())
			}
			else {}
		}
	}
}

pub struct TypingStart {
pub mut:
	channel_id string
	guild_id   string
	user_id    string
	timestamp  int
	member     Member
}

pub fn (mut ts TypingStart) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'channel_id' {
				ts.channel_id = v.str()
			}
			'guild_id' {
				ts.guild_id = v.str()
			}
			'user_id' {
				ts.user_id = v.str()
			}
			'timestamp' {
				ts.timestamp = v.int()
			}
			'member' {
				ts.member = from_json[Member](v.as_map())
			}
			else {}
		}
	}
}

pub type UserUpdate = User
pub type VoiceStateUpdate = VoiceState

pub struct VoiceServerUpdate {
pub mut:
	token    string
	guild_id string
	endpoint string
}

pub fn (mut vsu VoiceServerUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'token' {
				vsu.token = v.str()
			}
			'guild_id' {
				vsu.guild_id = v.str()
			}
			'endpoint' {
				vsu.endpoint = v.str()
			}
			else {}
		}
	}
}

pub struct WebhooksUpdate {
pub mut:
	guild_id   string
	channel_id string
}

pub fn (mut wu WebhooksUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'guild_id' {
				wu.guild_id = v.str()
			}
			'channel_id' {
				wu.channel_id = v.str()
			}
			else {}
		}
	}
}

pub type InteractionCreate = Interaction

// Publishing hello event to client eventbus
fn on_hello(mut client Client, hello &packets.Hello) {
	client.events.publish('hello', client, hello)
}

// Deals with packets from gateway. Publishing to client eventbus
fn on_dispatch(mut client Client, packet &packets.Packet) {
	event_name := packet.event.to_lower()
	mut data := packet.data.as_map()
	client.events.publish('dispatch', client, packet)
	match event_name {
		'ready' {
			mut obj := Ready{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'channel_create' {
			mut obj := ChannelCreate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'channel_update' {
			mut obj := ChannelUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'channel_delete' {
			mut obj := ChannelDelete{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'channel_pins_update' {
			mut obj := ChannelPinsUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_create' {
			mut obj := GuildCreate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_update' {
			mut obj := GuildUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_delete' {
			mut obj := GuildDelete{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_ban_add' {
			mut obj := GuildBanAdd{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_ban_remove' {
			mut obj := GuildBanRemove{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_emojis_update' {
			mut obj := GuildEmojisUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_integrations_update' {
			mut obj := GuildIntegrationsUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_member_add' {
			mut obj := GuildMemberAdd{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_member_remove' {
			mut obj := GuildMemberRemove{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_member_update' {
			mut obj := GuildMemberUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_members_chunk' {
			// TODO: Handle by nonce, return to rest
		}
		'guild_role_create' {
			mut obj := GuildRoleCreate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_role_update' {
			mut obj := GuildRoleUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'guild_role_delete' {
			mut obj := GuildRoleDelete{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'invite_create' {
			mut obj := InviteCreate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'invite_delete' {
			mut obj := InviteDelete{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_create' {
			mut obj := MessageCreate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_update' {
			mut obj := MessageUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_delete' {
			mut obj := MessageDelete{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_delete_bulk' {
			mut obj := MessageDeleteBulk{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_add' {
			mut obj := MessageReactionAdd{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_remove' {
			mut obj := MessageReactionRemove{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_remove_all' {
			mut obj := MessageReactionRemoveAll{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'message_reaction_remove_emoji' {
			mut obj := MessageReactionRemoveEmoji{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'presence_update' {
			mut obj := PresenceUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'typing_start' {
			mut obj := TypingStart{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'user_update' {
			mut obj := UserUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'voice_state_update' {
			mut obj := VoiceStateUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'voice_server_update' {
			mut obj := VoiceServerUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'webhooks_update' {
			mut obj := WebhooksUpdate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		'interaction_create' {
			mut obj := InteractionCreate{}
			obj.from_json(data)
			client.events.publish(event_name, client, obj)
		}
		else {
			client.log.info('Unhandled event: ${event_name}')
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
