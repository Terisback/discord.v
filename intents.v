module discordv

pub type Intent = i64

pub const (
	intent_guilds = Intent(1 << 0)
	intent_guild_members = Intent(1 << 1)
	intent_guild_bans = Intent(1 << 2)
	intent_guild_emojis = Intent(1 << 3)
	intent_guild_integrations = Intent(1 << 4)
	intent_guild_webhooks = Intent(1 << 5)
	intent_guild_invites = Intent(1 << 6)
	intent_guild_voice_states = Intent(1 << 7)
	intent_guild_precenses = Intent(1 << 8)
	intent_guild_messages = Intent(1 << 9)
	intent_guild_message_reactions = Intent(1 << 10)
	intent_guild_message_typing = Intent(1 << 11)
	intent_direct_messages = Intent(1 << 12)
	intent_direct_message_reactions = Intent(1 << 13)
	intent_direct_message_typing = Intent(1 << 14)
)