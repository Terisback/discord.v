module discordv

import time
import json
import x.json2
import snowflake

// Permission type
pub type Permission = int

pub struct AuditLog {
pub:
	webhooks          []Webhook
	users             []User
	audit_log_entries []AuditLogEntry
	integrations      []Integration
}

pub struct AuditLogEntry {
pub:
	target_id   string
	changes     []AuditLogChange
	user_id     string
	id          string
	action_type AuditLogEvent
	options     AuditEntryInfo
	reason      string
}

pub struct AuditLogChange {
pub:
	new_value string [raw]
	old_value string [raw]
	key       string // TODO: write module for managing audit log changes
}

pub enum AuditLogEvent {
	guild_update = 1
	channel_create = 10
	channel_update
	channel_delete
	channel_overwrite_create
	channel_overwrite_update
	channel_overwrite_delete
	member_kick = 20
	member_prune
	member_ban_add
	member_ban_remove
	member_update
	member_role_update
	member_move
	member_disconnect
	bot_add
	role_create = 30
	role_update
	role_delete
	invite_create = 40
	invite_update
	invite_delete
	webhook_create = 50
	webhook_update
	webhook_delete
	emoji_create = 60
	emoji_update
	emoji_delete
	message_delete = 72
	message_bulk_delete
	message_pin
	message_unpin
	integration_create = 80
	integration_update
	integration_delete
}

pub struct AuditEntryInfo {
pub:
	delete_member_days string
	members_removed    string
	channel_id         string
	message_id         string
	count              string
	id                 string
	@type              string [json: 'type']
	role_name          string
}

pub struct Activity {
pub:
	name           string
	@type          ActivityType        [json: 'type']
	url            string
	created_at     int
	timestamps     []ActivityTimestamp
	application_id string
	details        string
	state          string
	emoji          Emoji
	party          ActivityParty
	assets         ActivityAssets
	secrets        ActivitySecrets
	instance       bool
	flags          ActivityFlags
}

pub enum ActivityType {
	game
	streaming
	listening
	custom
	competing
}

pub struct ActivityTimestamp {
pub:
	start int
	end   int
}

pub struct ActivityParty {
pub:
	id   string
	size []int // length is 2
}

pub struct ActivityAssets {
pub:
	large_image string
	large_text  string
	small_image string
	small_text  string
}

pub struct ActivitySecrets {
pub:
	join     string
	spectate string
	@match   string [json: 'match']
}

pub type ActivityFlags = int

pub const (
	instance     = ActivityFlags(1 << 0)
	join         = ActivityFlags(1 << 1)
	spectate     = ActivityFlags(1 << 2)
	join_request = ActivityFlags(1 << 3)
	sync         = ActivityFlags(1 << 4)
	play         = ActivityFlags(1 << 5)
)

pub struct Attachment {
pub:
	id        string
	filename  string
	size      int
	url       string
	proxy_url string
	height    int
	width     int
}

enum PermissionOverwriteType {
	role
	user
}

struct PermissionOverwrite {
pub:
	id    string
	@type PermissionOverwriteType [json: 'type']
	allow string
	deny  string
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
pub:
	id       string
	guild_id string
	@type    ChannelType [json: 'type']
	name     string
}

pub struct Channel {
pub:
	id                    string
	@type                 ChannelType         [json: 'type']
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
pub mut:
	last_pin_timestamp time.Time
}

pub fn (mut channel Channel) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	if 'last_pin_timestamp' in f {
		channel.last_pin_timestamp = time.parse_iso8601(f['last_pin_timestamp'].str()) or {
			time.unix(int(snowflake.discord_epoch / 1000))
		}
	}
}

pub struct Message {
pub:
	id                string
	channel_id        string
	guild_id          string
	author            User
	member            Member
	content           string
	tts               bool
	mention_everyone  bool
	mentions          []User
	mention_roles     []string
	mention_channels  []ChannelMention
	attachments       []Attachment
	embeds            []Embed
	reactions         []Reaction
	nonce             string
	pinned            bool
	webhook_id        string
	@type             MessageType        [json: 'type']
	activity          MessageActivity
	application       MessageApplication
	message_reference MessageReference
	// referenced_message &Message = voidptr(0)
	stickers []Sticker
	flags    MessageFlag
pub mut:
	timestamp        time.Time
	edited_timestamp time.Time
}

pub enum MessageType {
	default
	recipient_add
	recipient_remove
	call
	channel_name_change
	channel_icon_change
	channel_pinned_message
	guild_member_join
	user_premium_guild_subscription
	user_premium_guild_subscription_tier_1
	user_premium_guild_subscription_tier_2
	user_premium_guild_subscription_tier_3
	channel_follow_add
	guild_discovery_disqualified
	guild_discovery_requalified
	reply = 19
	application_command
}

pub enum MessageActivityType {
	join = 1
	spectate = 2
	listen = 3
	join_request = 5
}

pub struct MessageActivity {
pub:
	@type    MessageActivityType [json: 'type']
	party_id string
}

pub struct MessageApplication {
pub:
	id          string
	cover_image string
	description string
	icon        string
	name        string
}

// Contains reference data with crossposted messages
pub struct MessageReference {
pub:
	message_id string
	channel_id string
	guild_id   string
}

fn (m MessageReference) iszero() bool {
	return json.encode(m) == json.encode(MessageReference{})
}

pub enum StickerType {
	png = 1
	apng
	lottie
}

pub struct Sticker {
pub:
	id            string
	pack_id       string
	name          string
	description   string
	tags          string
	asset         string
	preview_asset string
	format_type   StickerType
}

pub type MessageFlag = byte

pub const (
	crossposted            = MessageFlag(1 << 0)
	is_crosspost           = MessageFlag(1 << 1)
	suppress_embeds        = MessageFlag(1 << 2)
	source_message_deleted = MessageFlag(1 << 3)
	urgent                 = MessageFlag(1 << 4)
)

pub fn (mut m Message) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
			'timestamp' {
				m.timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'edited_timestamp' {
				m.edited_timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub struct Embed {
pub:
	title       string
	description string
	url         string
	color       int
	footer      EmbedFooter
	image       EmbedImage
	thumbnail   EmbedThumbnail
	video       EmbedVideo
	provider    EmbedProvider
	author      EmbedAuthor
	fields      []EmbedField
pub mut:
	timestamp time.Time
}

pub fn (embed Embed) iszero() bool {
	return json.encode(embed) == json.encode(Embed{})
}

pub fn (mut embed Embed) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
			'timestamp' {
				embed.timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub struct EmbedFooter {
pub:
	text           string
	icon_url       string
	proxy_icon_url string
}

pub struct EmbedImage {
pub:
	url       string
	proxy_url string
	height    int
	width     int
}

pub struct EmbedThumbnail {
pub:
	url       string
	proxy_url string
	height    int
	width     int
}

pub struct EmbedVideo {
pub:
	url    string
	height int
	width  int
}

pub struct EmbedProvider {
pub:
	name string
	url  string
}

pub struct EmbedAuthor {
pub:
	name           string
	url            string
	icon_url       string
	proxy_icon_url string
}

pub struct EmbedField {
pub:
	name   string
	value  string
	inline bool
}

pub struct Emoji {
pub:
	id    string
	name  string
	roles []Role
}

pub struct File {
pub:
	filename string
	data     []byte
}

pub struct UnavailableGuild {
pub:
	id          string
	unavailable bool
}

pub struct Member {
pub:
	user    User
	nick    string
	roles   []string
	deaf    bool
	mute    bool
	pending bool
pub mut:
	joined_at     time.Time
	premium_since time.Time
}

pub fn (mut member Member) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
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
			else {}
		}
	}
}

pub struct Reaction {
pub:
	count int
	me    bool
	emoji Emoji
}

pub struct Ready {
pub:
	v                int
	user             User
	private_channels []Channel
	guilds           []UnavailableGuild
	session_id       string
	shard            []int // length is 2
}

pub struct PresenceUpdate {
pub:
	user          User
	guild_id      string
	status        PresenceStatus
	activities    []Activity
	client_status PresenceClientStatus
}

pub type PresenceStatus = string

pub const (
	idle    = PresenceStatus('idle')
	dnd     = PresenceStatus('dnd')
	online  = PresenceStatus('online')
	offline = PresenceStatus('offline')
)

pub struct PresenceClientStatus {
pub:
	desktop PresenceStatus = discordv.offline
	mobile  PresenceStatus = discordv.offline
	web     PresenceStatus = discordv.offline
}

pub struct Guild {
pub:
	id                            string
	name                          string
	icon                          string
	icon_hash                     string
	splash                        string
	discovery_splash              string
	owner                         bool
	owner_id                      string
	permissions                   string
	region                        string
	afk_channel_id                string
	afk_timeout                   int
	widget_enabled                bool
	widget_channel_id             string
	verification_level            GuildVerificationLevel
	default_message_notifications GuildMessageNotificationsLevel
	explicit_content_filter       GuildExplicitContentFilterLevel
	roles                         []Role
	emojis                        []Emoji
	features                      []GuildFeature
	mfa_level                     MFALevel
	application_id                string
	system_channel_id             string
	system_channel_flags          string
	rules_channel_id              string
	large                         bool
	unavailable                   bool
	member_count                  int
	voice_states                  []VoiceState
	members                       []Member
	channels                      []Channel
	presences                     []PresenceUpdate
	max_presences                 int = 25000
	max_members                   int
	vanity_url_code               string
	description                   string
	banner                        string
	premium_tier                  GuildPremiumTier
	premium_subscription_count    int
	preferred_locale              string = 'en-US'
	public_updates_channel_id     string
	max_video_channel_users       int
	approximate_member_count      int
	approximate_presence_count    int
pub mut:
	joined_at time.Time
}

pub fn (mut guild Guild) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
			'joined_at' {
				guild.joined_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
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
	invite_splash          = GuildFeature('INVITE_SPLASH')
	vip_regions            = GuildFeature('VIP_REGIONS')
	vanity_url             = GuildFeature('VANITY_URL')
	verified               = GuildFeature('VERIFIED')
	partnered              = GuildFeature('PARTNERED')
	community              = GuildFeature('COMMUNITY')
	commerce               = GuildFeature('COMMERCE')
	news                   = GuildFeature('NEWS')
	discoverable           = GuildFeature('DISCOVERABLE')
	featurable             = GuildFeature('FEATURABLE')
	animated_icon          = GuildFeature('ANIMATED_ICON')
	banner                 = GuildFeature('BANNER')
	welcome_screen_enabled = GuildFeature('WELCOME_SCREEN_ENABLED')
)

pub enum MFALevel {
	@none
	elevated
}

pub type GuildSystemChannelFlags = int

pub const (
	suppress_join_notifications    = GuildSystemChannelFlags(1 << 0)
	suppress_premium_subscriptions = GuildSystemChannelFlags(1 << 1)
)

pub struct VoiceState {
pub:
	guild_id    string
	channel_id  string
	user_id     string
	member      Member
	session_id  string
	deaf        bool
	mute        bool
	self_deaf   bool
	self_mute   bool
	self_stream bool
	self_video  bool
	suppress    bool
}

pub enum GuildPremiumTier {
	@none
	tier_1
	tier_2
	tier_3
}

pub struct VoiceRegion {
pub:
	id         string
	name       string
	vip        bool
	optimal    bool
	deprecated bool
	custom     bool
}

pub struct Role {
pub:
	id          string
	name        string
	color       int
	hoist       bool
	position    int
	permission  string
	managed     bool
	mentionable bool
}

pub struct User {
pub:
	id            string
	username      string
	discriminator string
	avatar        string
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

pub fn (user User) avatar_url() string {
	return 'https://cdn.discordapp.com/avatars/$user.id/{$user.avatar}.png'
}

pub type UserFlag = int

pub const (
	zero                         = UserFlag(0)
	discord_employee             = UserFlag(1 << 0)
	partnered_server_owner       = UserFlag(1 << 1)
	hypersquad_events            = UserFlag(1 << 2)
	bughunter_level1             = UserFlag(1 << 3)
	house_bravery                = UserFlag(1 << 6)
	house_brilliance             = UserFlag(1 << 7)
	house_balance                = UserFlag(1 << 8)
	early_supporter              = UserFlag(1 << 9)
	team_user                    = UserFlag(1 << 10)
	system                       = UserFlag(1 << 12)
	bughunter_level2             = UserFlag(1 << 14)
	verified_bot                 = UserFlag(1 << 16)
	early_verified_bot_developer = UserFlag(1 << 17)
)

pub enum PremiumType {
	@none
	nitro_classic
	nitro
}

pub enum IntegrationExpireBehavior {
	remove_role
	kick
}

pub type IntegrationType = string

pub const (
	twitch  = IntegrationType('twitch')
	youtube = IntegrationType('youtube')
	discord = IntegrationType('discord')
)

pub struct IntegrationAccount {
pub:
	id   string
	name string
}

pub struct IntegrationApplication {
pub:
	id          string
	name        string
	icon        string
	description string
	summary     string
	bot         User
}

pub struct Integration {
pub:
	id                  string
	name                string
	@type               IntegrationType           [json: 'type']
	enabled             bool
	syncing             bool
	role_id             string
	enable_emoticons    bool
	expire_behavior     IntegrationExpireBehavior
	expire_grace_period int
	user                User
	account             IntegrationAccount
	subscriber_count    int
	revoked             bool
	application         IntegrationApplication
pub mut:
	synced_at time.Time
}

pub fn (mut integration Integration) from_json(data string) {
	obj := json2.raw_decode(data) or { return }
	f := obj.as_map()
	for k, v in f {
		match k {
			'synced_at' {
				integration.synced_at = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			else {}
		}
	}
}

pub struct Interaction {
pub:
	id         string
	@type      InteractionType                   [json: 'type']
	data       ApplicationCommandInteractionData
	guild_id   string
	channel_id string
	member     Member
	token      string
	version    int
}

pub enum InteractionType {
	ping = 1
	application_command = 2
}

pub struct ApplicationCommandInteractionData {
pub:
	id      string
	name    string
	options []ApplicationCommandInteractionDataOption
}

pub struct ApplicationCommandInteractionDataOption {
pub:
	name  string
	value string
	// options []&ApplicationCommandInteractionDataOption
}

pub struct Webhook {
pub mut:
	id             string
	@type          WebhookType [json: 'type']
	guild_id       string
	channel_id     string
	user           User
	name           string
	avatar         string
	token          string
	application_id string
}

pub enum WebhookType {
	incoming = 1
	channel_follower
}
