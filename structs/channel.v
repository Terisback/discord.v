module structs

import time

// Do we really need that level of abstraction?
pub type Channel = TextChannel | DMChannel | VoiceChannel | DMGroupChannel | Category | NewsChannel | StoreChannel

enum PermissionOverwriteType{
	role
	user
}

struct PermissionOverwrite {
	id string
	@type PermissionOverwriteType
	allow string
	deny string
}

pub struct TextChannel {
	id string
	guild_id string
	name string
	position int
	permission_overwrites []PermissionOverwrite
	rate_limit_per_user int
	nsfw bool
	topic string
	last_message_id string
	parent_id string
}

pub struct DMChannel {
	last_message_id string
	id string
	recipients []User
}

pub struct VoiceChannel {
	id string
	guild_id string
	name string
	nsfw bool
	position int
	permission_overwrites []PermissionOverwrite
	bitrate int
	user_limit int
	parent_id string
}

pub struct DMGroupChannel {
	name string
	icon string
	recipients []User
	last_message_id string
	id string
	owner_id string
}

pub struct Category {
	permission_overwrites []PermissionOverwrite
	name string
	parent_id string
	nsfw bool
	position int
	guild_id string
	id string
}

pub struct NewsChannel {
	id string
	guild_id string
	name string
	position int
	permission_overwrites []PermissionOverwrite
	nsfw bool
	topic string
	last_message_id string
	parent_id string
}

pub struct StoreChannel {
	id string
	guild_id string
	name string
	position int
	permission_overwrites []PermissionOverwrite
	nsfw bool
	parent_id string
}
