module discordv

pub struct Config {
pub mut:
	token string
	intents Intent = intents.guilds | intents.guild_messages
}