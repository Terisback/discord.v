module discordv

import time
import x.json2 as json
import discordv.util.snowflake

pub struct Activity {
pub mut:
	name string
	@type ActivityType
	url string
	created_at int
	timestamps []ActivityTimestamp
	application_id string
	details string
	state string
	emoji Emoji
	party ActivityParty
	assets ActivityAssets
	secrets ActivitySecrets
	instance bool
	flags ActivityFlags
}

pub fn (mut activity Activity) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'name' {
				activity.name = v.str()
			}
			'type' {
				activity.@type = ActivityType(v.int())
			}
			'url' {
				activity.url = v.str()
			}
			'created_at' {
				activity.created_at = v.int()
			}
			'timestamps' {
				activity.timestamps = from_json_arr<ActivityTimestamp>(v.arr())
			}
			'application_id' {
				activity.application_id = v.str()
			}
			'details' {
				activity.details = v.str()
			}
			'state' {
				activity.state = v.str()
			}
			'emoji' {
				activity.emoji = from_json<Emoji>(v.as_map())
			}
			'party' {
				activity.party = from_json<ActivityParty>(v.as_map())
			}
			'assets' {
				activity.assets = from_json<ActivityAssets>(v.as_map())
			}
			'secrets' {
				activity.secrets = from_json<ActivitySecrets>(v.as_map())
			}
			'instance' {
				activity.instance = v.bool()
			}
			'flags' {
				activity.flags = ActivityFlags(v.int())
			}
			else {}
		}
	}
}

pub enum ActivityType {
	game
	streaming
	listening
	custom
	competing
}

pub struct ActivityTimestamp {
pub mut:
	start int
	end int
}

pub fn (mut at ActivityTimestamp) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'start' {
				at.start = v.int()
			}
			'end' {
				at.end = v.int()
			}
			else {}
		}
	}
}

pub struct ActivityParty {
pub mut:
	id string
	size [2]int
}

pub fn (mut ap ActivityParty) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'id' {
				ap.id = v.str()
			}
			'size' {
				mut arr := v.arr()
				ap.size[0] = arr[0].int()
				ap.size[1] = arr[1].int()
			}
			else {}
		}
	}
}

pub struct ActivityAssets {
pub mut:
	large_image string
	large_text string
	small_image string
	small_text string
}

pub fn (mut aa ActivityAssets) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'large_image' {
				aa.large_image = v.str()
			}
			'large_text' {
				aa.large_text = v.str()
			}
			'small_image' {
				aa.small_image = v.str()
			}
			'small_text' {
				aa.small_text = v.str()
			}
			else {}
		}
	}
}

pub struct ActivitySecrets {
pub mut:
	join string
	spectate string
	@match string
}

pub fn (mut ass ActivitySecrets) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'join' {
				ass.join = v.str()
			}
			'spectate' {
				ass.spectate = v.str()
			}
			'match' {
				ass.@match = v.str()
			}
			else {}
		}
	}
}

pub type ActivityFlags = int

pub const (
	INSTANCE = ActivityFlags(1 << 0)
	JOIN = ActivityFlags(1 << 1)
	SPECTATE = ActivityFlags(1 << 2)
	JOIN_REQUEST = ActivityFlags(1 << 3)
	SYNC = ActivityFlags(1 << 4)
	PLAY = ActivityFlags(1 << 5)
)

pub struct Attachment {
pub mut:
	id string
	filename string
	size int
	url string
	proxy_url string
	height int
	width int
}

pub fn (mut at Attachment) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'id' {at.id = v.str()}
			'filename' {at.filename = v.str()}
			'size' {at.size = v.int()}
			'url' {at.url = v.str()}
			'proxy_url' {at.proxy_url = v.str()}
			'height' {at.height = v.int()}
			'width' {at.width = v.int()}
			else {}
		}
	}
}

enum PermissionOverwriteType {
	role
	user
}

struct PermissionOverwrite {
pub mut:
	id    string
	@type PermissionOverwriteType
	allow string
	deny  string
}

pub fn (mut po PermissionOverwrite) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'id' { po.id = v.str() }
			'type' { po.@type = PermissionOverwriteType(v.int()) }
			'allow' { po.allow = v.str() }
			'deny' { po.deny = v.str() }
			else {}
		}
	}
}

enum ChannelType {
	guild_text
	dm
	guild_voice
	group_dm
	guild_category
	guild_news
	guild_store
}

pub struct ChannelMention {
pub mut:
	id string
	guild_id string
	@type ChannelType
	name string
}

pub fn (mut cm ChannelMention) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k{
			'id' {cm.id = v.str()}
			'guild_id' {cm.guild_id = v.str()}
			'type' {cm.@type = ChannelType(v.int())}
			'name' {cm.name = v.str()}
			else {}
		}
	}
}

pub struct Channel {
pub mut:
	id                    string
	@type                 ChannelType
	guild_id              string
	position              int
	permission_overwrites PermissionOverwrite
	name                  string
	topic                 string
	nsfw                  bool
	last_message_id       string
	bitrate               int
	user_limit            int
	rate_limit_per_user   int
	recipients            []User
	icon                  string
	owner_id              string
	application_id        string
	parent_id             string
	last_pin_timestamp    time.Time
}

pub fn (mut channel Channel) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'id' {
				channel.id = v.str()
			}
			'type' {
				channel.@type = ChannelType(v.int())
			}
			'guild_id' {
				channel.guild_id = v.str()
			}
			'position' {
				channel.position = v.int()
			}
			'permission_overwrites' {
				channel.permission_overwrites = from_json<PermissionOverwrite>(v.as_map())
			}
			'name' {
				channel.name = v.str()
			}
			'topic' {
				channel.topic = v.str()
			}
			'nsfw' {
				channel.nsfw = v.bool()
			}
			'last_message_id' {
				channel.last_message_id = v.str()
			}
			'bitrate' {
				channel.bitrate = v.int()
			}
			'user_limit' {
				channel.user_limit = v.int()
			}
			'rate_limit_per_user' {
				channel.rate_limit_per_user = v.int()
			}
			'recipients' {
				channel.recipients = from_json_arr<User>(v.arr())
			}
			'icon' {
				channel.icon = v.str()
			}
			'owner_id' {
				channel.owner_id = v.str()
			}
			'application_id' {
				channel.application_id = v.str()
			}
			'parent_id' {
				channel.parent_id = v.str()
			}
			'last_pin_timestamp' {
				channel.last_pin_timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub struct Emoji {
pub mut:
	id    string
	name  string
	roles []Role
}

pub fn (mut emoji Emoji) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'id' {
				emoji.id = v.str()
			}
			'name' {
				emoji.name = v.str()
			}
			'roles' {
				emoji.roles = from_json_arr<Role>(v.arr())
			}
			else {}
		}
	}
}

pub struct File {
pub mut:
	filename string
	data     []byte
}

pub struct UnavailableGuild {
pub mut:
	id          string
	unavailable bool
}

fn (mut g UnavailableGuild) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'id' { g.id = v.str() }
			'unavailable' { g.unavailable = v.bool() }
			else {}
		}
	}
}

pub struct Member {
pub mut:
	user User
	nick string
	roles []string
	joined_at time.Time
	premium_since time.Time
	deaf bool
	mute bool
	pending bool
}

pub fn (mut member Member) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'user' {
				member.user = from_json<User>(v.as_map())
			}
			'nick' {member.nick = v.str()}
			'roles' {
				mut roles := v.arr()
				for role in roles {
					member.roles << role.str()
				}
			}
			'joined_at' {
				member.joined_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'premium_since' {
				member.premium_since = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'deaf' {member.deaf = v.bool()}
			'mute' {member.mute = v.bool()}
			'pending' {member.pending = v.bool()}
			else{}
		}
	}
}

pub struct Reaction {
pub mut:
	count int
	me    bool
	emoji Emoji
}

pub fn (mut r Reaction) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'count' {
				r.count = v.int()
			}
			'me' {
				r.me = v.bool()
			}
			'emoji' {
				r.emoji = from_json<Emoji>(v.as_map())
			}
			else {}
		}
	}
}

pub struct Ready {
pub mut:
	v                int
	user             User
	private_channels []Channel
	guilds           []UnavailableGuild
	session_id       string
	shard            [2]int
}

pub fn (mut r Ready) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'v' {
				r.v = v.int()
			}
			'user' {
				r.user = from_json<User>(v.as_map())
			}
			'private_channels' {
				r.private_channels = from_json_arr<Channel>(v.arr())
			}
			'guilds' {
				r.guilds = from_json_arr<UnavailableGuild>(v.arr())
			}
			'session_id' {
				r.session_id = v.str()
			}
			'shard' {
				mut shards := v.arr()
				r.shard[0] = shards[0].int()
				r.shard[1] = shards[1].int()
			}
			else {}
		}
	}
}

pub struct PresenceUpdate {
pub mut:
	user User
	guild_id string
	status PresenceStatus
	activities []Activity
	client_status PresenceClientStatus
}

pub fn (mut pu PresenceUpdate) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'user' {
				pu.user = from_json<User>(v.as_map())
			}
			'guild_id' {
				pu.guild_id = v.str()
			}
			'status' {
				pu.status = PresenceStatus(v.str())
			}
			'activities' {
				pu.activities = from_json_arr<Activity>(v.arr())
			}
			'client_status' {
				pu.client_status = from_json<PresenceClientStatus>(v.as_map())
			}
			else {}
		}
	}
}

pub type PresenceStatus = string

pub const (
	idle = PresenceStatus('idle')
	dnd = PresenceStatus('dnd')
	online = PresenceStatus('online')
	offline = PresenceStatus('offline')
)

pub struct PresenceClientStatus {
pub mut:
	desktop PresenceStatus = offline
	mobile PresenceStatus = offline
	web PresenceStatus = offline
}

pub fn (mut pcs PresenceClientStatus) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'desktop' {
				pcs.desktop = PresenceStatus(v.str())
			}
			'mobile' {
				pcs.mobile = PresenceStatus(v.str())
			}
			'web' {
				pcs.web = PresenceStatus(v.str())
			}
			else {}
		}
	}
}

pub struct Guild {
pub mut:
	id string
	name string
	icon string
	icon_hash string
	splash string
	discovery_splash string
	owner bool
	owner_id string
	permissions string
	region string
	afk_channel_id string
	afk_timeout int
	widget_enabled bool
	widget_channel_id string
	verification_level GuildVerificationLevel
	default_message_notifications GuildMessageNotificationsLevel
	explicit_content_filter GuildExplicitContentFilterLevel
	roles []Role
	emojis []Emoji
	features []GuildFeature
	mfa_level MFALevel
	application_id string
	system_channel_id string
	system_channel_flags string
	rules_channel_id string
	joined_at time.Time
	large bool
	unavailable bool
	member_count int
	voice_states []VoiceState
	members []Member
	channels []Channel
	presences []PresenceUpdate
	max_presences int = 25000
	max_members int
	vanity_url_code string
	description string
	banner string
	premium_tier GuildPremiumTier
	premium_subscription_count int
	preferred_locale string = "en-US"
	public_updates_channel_id string
	max_video_channel_users int
	approximate_member_count int
	approximate_presence_count int
}

pub fn (mut guild Guild) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'id' {
				guild.id = v.str()
			}
			'name' {
				guild.name = v.str()
			}
			'icon' {
				guild.icon = v.str()
			}
			'icon_hash'{
				guild.icon_hash = v.str()
			}
			'splash' {
				guild.splash = v.str()
			}
			'discovery_splash'{
				guild.discovery_splash = v.str()
			}
			'owner' {
				guild.owner = v.bool()
			}
			'owner_id' {
				guild.owner_id = v.str()
			}
			'permissions' {
				guild.permissions = v.str()
			}
			'region' {
				guild.region = v.str()
			}
			'afk_channel_id' {
				guild.afk_channel_id = v.str()
			}
			'afk_timeout' {
				guild.afk_timeout = v.int()
			}
			'widget_enabled' {
				guild.widget_enabled = v.bool()
			}
			'widget_channel_id' {
				guild.widget_channel_id = v.str()
			}
			'verification_level' {
				guild.verification_level = GuildVerificationLevel(v.int())
			}
			'default_message_notifications' {
				guild.default_message_notifications = GuildMessageNotificationsLevel(v.int())
			}
			'explicit_content_filter' {
				guild.explicit_content_filter = GuildExplicitContentFilterLevel(v.int())
			}
			'roles' {
				guild.roles = from_json_arr<Role>(v.arr())
			}
			'emojis' {
				guild.emojis = from_json_arr<Emoji>(v.arr())
			}
			'features' {
				mut roles := v.arr()
				for role in roles {
					guild.features << GuildFeature(role.str())
				}
			}
			'mfa_level' {
				guild.mfa_level = MFALevel(v.int())
			}
			'application_id' {
				guild.application_id = v.str()
			}
			'system_channel_id' {
				guild.system_channel_id = v.str()
			}
			'system_channel_flags' {
				guild.system_channel_flags = v.str()
			}
			'rules_channel_id' {
				guild.rules_channel_id = v.str()
			}
			'joined_at' {
				guild.joined_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'large' {
				guild.large = v.bool()
			}
			'unavailable' {
				guild.unavailable = v.bool()
			}
			'member_count' {
				guild.member_count = v.int()
			}
			'voice_states' {
				guild.voice_states = from_json_arr<VoiceState>(v.arr())
			}
			'members' {
				guild.members = from_json_arr<Member>(v.arr())
			}
			'channels' {
				guild.channels = from_json_arr<Channel>(v.arr())
			}
			'presences' {
				guild.presences = from_json_arr<PresenceUpdate>(v.arr())
			}
			'max_presences' {
				guild.max_presences = v.int()
			}
			'max_members' {
				guild.max_members = v.int()
			}
			'vanity_url_code' {
				guild.vanity_url_code = v.str()
			}
			'description' {
				guild.description = v.str()
			}
			'banner' {
				guild.banner = v.str()
			}
			'premium_tier' {
				guild.premium_tier = GuildPremiumTier(v.int())
			}
			'premium_subscription_count' {
				guild.premium_subscription_count = v.int()
			}
			'preferred_locale' {
				guild.preferred_locale = v.str()
			}
			'public_updates_channel_id' {
				guild.public_updates_channel_id = v.str()
			}
			'max_video_channel_users' {
				guild.max_video_channel_users = v.int()
			}
			'approximate_member_count' {
				guild.approximate_member_count = v.int()
			}
			'approximate_presence_count' {
				guild.approximate_presence_count = v.int()
			}
			else {}
		}
	}
}

pub enum GuildVerificationLevel {
	@none
	low
	medium
	high
	very_high
}

pub enum GuildMessageNotificationsLevel {
	all_messages
	only_mentions
}

pub enum GuildExplicitContentFilterLevel {
	disabled
	members_without_roles
	all_members
}

pub type GuildFeature = string

pub const (
	INVITE_SPLASH = GuildFeature("INVITE_SPLASH")
	VIP_REGIONS = GuildFeature("VIP_REGIONS")
	VANITY_URL = GuildFeature("VANITY_URL")
	VERIFIED = GuildFeature("VERIFIED")
	PARTNERED = GuildFeature("PARTNERED")
	COMMUNITY = GuildFeature("COMMUNITY")
	COMMERCE = GuildFeature("COMMERCE")
	NEWS = GuildFeature("NEWS")
	DISCOVERABLE = GuildFeature("DISCOVERABLE")
	FEATURABLE = GuildFeature("FEATURABLE")
	ANIMATED_ICON = GuildFeature("ANIMATED_ICON")
	BANNER = GuildFeature("BANNER")
	WELCOME_SCREEN_ENABLED = GuildFeature("WELCOME_SCREEN_ENABLED")
)

pub enum MFALevel {
	@none
	elevated
}

pub type GuildSystemChannelFlags = int

pub const (
	SUPPRESS_JOIN_NOTIFICATIONS = GuildSystemChannelFlags(1 << 0)
	SUPPRESS_PREMIUM_SUBSCRIPTIONS = GuildSystemChannelFlags(1 << 1)
)

pub struct VoiceState {
pub mut:
	guild_id string
	channel_id string
	user_id string
	member Member
	session_id string
	deaf bool
	mute bool
	self_deaf bool
	self_mute bool
	self_stream bool
	self_video bool
	suppress bool
}

pub fn (mut vs VoiceState) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'guild_id' {
				vs.guild_id = v.str()
			}
			'channel_id' {
				vs.channel_id = v.str()
			}
			'user_id' {
				vs.user_id = v.str()
			}
			'member' {
				vs.member = from_json<Member>(v.as_map())
			}
			'session_id' {
				vs.session_id = v.str()
			}
			'deaf' {
				vs.deaf = v.bool()
			}
			'mute' {
				vs.mute = v.bool()
			}
			'self_deaf' {
				vs.self_deaf = v.bool()
			}
			'self_mute' {
				vs.self_mute = v.bool()
			}
			'self_stream' {
				vs.self_stream = v.bool()
			}
			'self_video' {
				vs.self_video = v.bool()
			}
			'suppress' {
				vs.suppress = v.bool()
			}
			else {}
		}
	}
}

pub enum GuildPremiumTier {
	@none
	tier_1
	tier_2
	tier_3
}

pub struct VoiceRegion {
pub mut:
	id string
	name string
	vip bool
	optimal bool
	deprecated bool
	custom bool
}

pub fn (mut vr VoiceRegion) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'id' {
				vr.id = v.str()
			}
			'name' {
				vr.name = v.str()
			}
			'vip' {
				vr.vip = v.bool()
			}
			'optimal' {
				vr.optimal = v.bool()
			}
			'deprecated' {
				vr.deprecated = v.bool()
			}
			'custom' {
				vr.custom = v.bool()
			}
			else {}
		}
	}
}

pub struct Role {
pub mut:
	id          string
	name        string
	color       int
	hoist       bool
	position    int
	permission  string
	managed     bool
	mentionable bool
}

pub fn (mut role Role) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'id' { role.id = v.str() }
			'name' { role.name = v.str() }
			'color' { role.color = v.int() }
			'hoist' { role.hoist = v.bool() }
			'position' { role.position = v.int() }
			'permission' { role.permission = v.str() }
			'managed' { role.managed = v.bool() }
			'mentionable' { role.mentionable = v.bool() }
			else {}
		}
	}
}

pub struct User {
pub mut:
	id            string
	username      string
	discriminator string
	avatar        Avatar
	bot           bool
	system        bool
	mfa_enabled   bool
	locale        string
	verified      bool
	email         string
	flags         UserFlag
	premium_type  PremiumType
	public_flags  UserFlag
}

pub struct Avatar {
	user_id string
pub:
	hash    string
}

pub fn (avatar Avatar) url() string {
	return 'https://cdn.discordapp.com/avatars/$avatar.user_id/{$avatar.hash}.png'
}

pub fn (avatar Avatar) str() string {
	return avatar.hash
}

pub type UserFlag = int

pub struct UserFlags {
pub:
	zero                         UserFlag = UserFlag(0)
	discord_employee             UserFlag = UserFlag(1 << 0)
	partnered_server_owner       UserFlag = UserFlag(1 << 1)
	hypersquad_events            UserFlag = UserFlag(1 << 2)
	bughunter_level1             UserFlag = UserFlag(1 << 3)
	house_bravery                UserFlag = UserFlag(1 << 6)
	house_brilliance             UserFlag = UserFlag(1 << 7)
	house_balance                UserFlag = UserFlag(1 << 8)
	early_supporter              UserFlag = UserFlag(1 << 9)
	team_user                    UserFlag = UserFlag(1 << 10)
	system                       UserFlag = UserFlag(1 << 12)
	bughunter_level2             UserFlag = UserFlag(1 << 14)
	verified_bot                 UserFlag = UserFlag(1 << 16)
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

pub fn (mut user User) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj {
		match k {
			'id' { user.id = v.str() }
			'username' { user.username = v.str() }
			'discriminator' { user.discriminator = v.str() }
			'bot' { user.bot = v.bool() }
			'system' { user.system = v.bool() }
			'mfa_enabled' { user.mfa_enabled = v.bool() }
			'locale' { user.locale = v.str() }
			'verified' { user.verified = v.bool() }
			'email' { user.email = v.str() }
			'flags' { user.flags = UserFlag(v.int()) }
			'premium_type' { user.premium_type = PremiumType(v.int()) }
			'public_flags' { user.public_flags = UserFlag(v.int()) }
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

pub enum IntegrationExpireBehavior {
	remove_role
	kick
}

pub type IntegrationType = string

pub const(
	twitch = IntegrationType('twitch')
	youtube = IntegrationType('youtube')
	discord = IntegrationType('discord')
)

pub struct IntegrationAccount {
pub mut:
	id string
	name string
}

pub fn (mut iacc IntegrationAccount) from_json(f map[string]json.Any) {
	mut obj := f
	for k, v in obj{
		match k {
			'id' {iacc.id = v.str()}
			'name' {iacc.name = v.str()}
			else {}
		}
	}
}

pub struct IntegrationApplication {
pub mut:
	id string
	name string
	icon string
	description string
	summary string
	bot User
}

pub fn (mut iapp IntegrationApplication) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'id' {iapp.id = v.str()}
			'name' {iapp.name = v.str()}
			'icon' {iapp.icon = v.str()}
			'description' {iapp.description = v.str()}
			'summary' {iapp.summary = v.str()}
			'bot' {
				iapp.bot = from_json<User>(v.as_map())
			}
			else {}
		}
	}
}

pub struct Integration {
pub mut:
	id string
	name string
	@type IntegrationType
	enabled bool
	syncing bool
	role_id string
	enable_emoticons bool
	expire_behavior IntegrationExpireBehavior
	expire_grace_period int
	user User
	account IntegrationAccount
	synced_at time.Time
	subscriber_count int
	revoked bool
	application IntegrationApplication
}

pub fn (mut integration Integration) from_json(f map[string]json.Any){
	mut obj := f
	for k, v in obj{
		match k {
			'id' {integration.id = v.str()}
			'name' {integration.name = v.str()}
			'type' {integration.@type = IntegrationType(v.str())}
			'enabled' {integration.enabled = v.bool()}
			'syncing' {integration.syncing = v.bool()}
			'role_id' {integration.role_id = v.str()}
			'enable_emoticons' {integration.enable_emoticons = v.bool()}
			'expire_behavior' {integration.expire_behavior = IntegrationExpireBehavior(v.int())}
			'expire_grace_period' {integration.expire_grace_period = v.int()}
			'user' {
				integration.user = from_json<User>(v.as_map())
			}
			'account' {
				integration.account = from_json<IntegrationAccount>(v.as_map())
			}
			'synced_at' {
				integration.synced_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'subscriber_count' {integration.subscriber_count = v.int()}
			'revoked' {integration.revoked = v.bool()}
			'application' {
				integration.application = from_json<IntegrationApplication>(v.as_map())
			}
			else{}
		}
	}
}

fn from_json<T> (f map[string]json.Any) T {
	mut obj := T{}
	obj.from_json(f)
	return obj
}

fn from_json_arr<T>(f []json.Any) []T {
	mut arr := []T{}
	for fs in f {
		mut item := T{}
		item.from_json(fs.as_map())
		arr << item
	}
	return arr
}