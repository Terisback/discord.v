module gateway

// Intent type for gateway connection
pub type Intent = u16

// Constants for the different bit offsets of intents
pub const (
	guilds                   = Intent(1 << 0)
	guild_members            = Intent(1 << 1)
	guild_bans               = Intent(1 << 2)
	guild_emojis             = Intent(1 << 3)
	guild_integrations       = Intent(1 << 4)
	guild_webhooks           = Intent(1 << 5)
	guild_invites            = Intent(1 << 6)
	guild_voice_states       = Intent(1 << 7)
	guild_precenses          = Intent(1 << 8)
	guild_messages           = Intent(1 << 9)
	guild_message_reactions  = Intent(1 << 10)
	guild_message_typing     = Intent(1 << 11)
	direct_messages          = Intent(1 << 12)
	direct_message_reactions = Intent(1 << 13)
	direct_message_typing    = Intent(1 << 14)
	all_allowed              = Intent(32509)
	all                      = Intent(32767)
)