module discordv

import discordv.types

pub struct Config {
pub mut:
	token string
	intents types.Intent = intents.guilds | intents.guild_messages
}