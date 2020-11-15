module discordv

import discordv.structs

pub enum Event {
	hello
	ready
	resumed
	reconnect
	invalid_session
	channel_create
	channel_update
	channel_delete
	channel_pins_update
	guild_create
	guild_update
	guild_delete
	guild_ban_add
	guild_ban_remove
	guild_emojis_update
	guild_integrations_update
	guild_member_add
	guild_member_remove
	guild_member_update
	guild_members_chunk
	guild_role_create
	guild_role_update
	guild_role_delete
	invite_create
	invite_delete
	message_create
	message_update
	message_delete
	message_delete_bulk
	message_reaction_add
	message_reaction_remove
	message_reaction_remove_all
	message_reaction_remove_emoji
	presence_update
	typing_start
	user_update
	voice_state_update
	voice_server_update
	webhooks_update
}

pub type Hello = structs.Hello
pub type Ready = structs.Ready
// pub type Resumed = structs.Resumed
pub type Reconnect = structs.Reconnect
// pub type InvalidSession = structs.InvalidSession
pub type MessageCreate = structs.Message
pub type MessageUpdate = structs.Message
pub type MessageDelete = structs.Message