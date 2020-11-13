module discordv

pub type Intent = u16

pub struct Intents {
pub:
	guilds Intent = Intent(1 << 0)
	guild_members Intent = Intent(1 << 1)
	guild_bans Intent = Intent(1 << 2)
	guild_emojis Intent = Intent(1 << 3)
	guild_integrations Intent = Intent(1 << 4)
	guild_webhooks Intent = Intent(1 << 5)
	guild_invites Intent = Intent(1 << 6)
	guild_voice_states Intent = Intent(1 << 7)
	guild_precenses Intent = Intent(1 << 8)
	guild_messages Intent = Intent(1 << 9)
	guild_message_reactions Intent = Intent(1 << 10)
	guild_message_typing Intent = Intent(1 << 11)
	direct_messages Intent = Intent(1 << 12)
	direct_message_reactions Intent = Intent(1 << 13)
	direct_message_typing Intent = Intent(1 << 14)
	all_allowed Intent = Intent(32509)
	all Intent = Intent(32767)
}

pub const (
	intents = Intents{}
)