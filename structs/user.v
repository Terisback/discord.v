module structs

import x.json2 as json

pub struct User {
pub mut:
	id string
	username string
	discriminator string
	avatar Avatar
	bot bool
	system bool
	mfa_enabled bool
	locale string
	verified bool
	email string
	flags UserFlag
	premium_type PremiumType
	public_flags UserFlag 
}

pub struct Avatar {
	user_id string
pub:
	hash string
}

pub fn (avatar Avatar) url() string{
	return 'https://cdn.discordapp.com/avatars/$avatar.user_id/{$avatar.hash}.png'
}

pub fn (avatar Avatar) str() string{
	return avatar.hash
}

pub type UserFlag = int

pub struct UserFlags {
pub:
	zero UserFlag = UserFlag(0)
	discord_employee UserFlag = UserFlag(1 << 0)
	partnered_server_owner UserFlag = UserFlag(1 << 1)
	hypersquad_events UserFlag = UserFlag(1 << 2)
	bughunter_level1 UserFlag = UserFlag(1 << 3)
	house_bravery UserFlag = UserFlag(1 << 6)
	house_brilliance UserFlag = UserFlag(1 << 7)
	house_balance UserFlag = UserFlag(1 << 8)
	early_supporter UserFlag = UserFlag(1 << 9)
	team_user UserFlag = UserFlag(1 << 10)
	system UserFlag = UserFlag(1 << 12)
	bughunter_level2 UserFlag = UserFlag(1 << 14)
	verified_bot UserFlag = UserFlag(1 << 16)
	early_verified_bot_developer UserFlag = UserFlag(1 << 17)
}

pub const (
	user_flags = UserFlags{}
)

pub enum PremiumType {
	@none
	nitro_classic
	nitro
}

pub fn (mut user User) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'id' {user.id = v.str()}
			'username' {user.username = v.str()}
			'discriminator' {user.discriminator = v.str()}
			'bot' {user.bot = v.bool()}
			'system' {user.system = v.bool()}
			'mfa_enabled' {user.mfa_enabled = v.bool()}
			'locale' {user.locale = v.str()}
			'verified' {user.verified = v.bool()}
			'email' {user.email = v.str()}
			'flags' {user.flags = UserFlag(v.int())}
			'premium_type' {user.premium_type = PremiumType(v.int())}
			'public_flags' {user.public_flags = UserFlag(v.int())}
			else {} 
		}
	}
	if 'avatar' in obj {
		hash := obj['avatar'].str()
		user.avatar = Avatar{
			user_id: user.id
			hash: hash
		}
	}
}