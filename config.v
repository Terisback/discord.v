module discordv

pub struct Config {
pub mut:
	token string
	shard_count int = 1
	intents Intent = intents.guilds | intents.guild_messages
}