module discordv

import discordv.types

pub struct Intents {
pub:
	guilds                   types.Intent = types.Intent(1 << 0)
	guild_members            types.Intent = types.Intent(1 << 1)
	guild_bans               types.Intent = types.Intent(1 << 2)
	guild_emojis             types.Intent = types.Intent(1 << 3)
	guild_integrations       types.Intent = types.Intent(1 << 4)
	guild_webhooks           types.Intent = types.Intent(1 << 5)
	guild_invites            types.Intent = types.Intent(1 << 6)
	guild_voice_states       types.Intent = types.Intent(1 << 7)
	guild_precenses          types.Intent = types.Intent(1 << 8)
	guild_messages           types.Intent = types.Intent(1 << 9)
	guild_message_reactions  types.Intent = types.Intent(1 << 10)
	guild_message_typing     types.Intent = types.Intent(1 << 11)
	direct_messages          types.Intent = types.Intent(1 << 12)
	direct_message_reactions types.Intent = types.Intent(1 << 13)
	direct_message_typing    types.Intent = types.Intent(1 << 14)
	all_allowed              types.Intent = types.Intent(32509)
	all                      types.Intent = types.Intent(32767)
}

pub const (
	intents = Intents{}
)
