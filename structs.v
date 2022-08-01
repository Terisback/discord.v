module discordv

import time
import x.json2 as json
import snowflake

// Permission type
pub type Permission = int

pub struct AuditLog {
pub mut:
	webhooks          []Webhook
	users             []User
	audit_log_entries []AuditLogEntry
	integrations      []Integration
}

pub fn (mut al AuditLog) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'webhooks' {
				al.webhooks = from_json_arr<Webhook>(v.arr())
			}
			'users' {
				al.users = from_json_arr<User>(v.arr())
			}
			'audit_log_entries' {
				al.audit_log_entries = from_json_arr<AuditLogEntry>(v.arr())
			}
			'integrations' {
				al.integrations = from_json_arr<Integration>(v.arr())
			}
			else {}
		}
	}
}

pub struct AuditLogEntry {
pub mut:
	target_id   string
	changes     []AuditLogChange
	user_id     string
	id          string
	action_type AuditLogEvent
	options     AuditEntryInfo
	reason      string
}

pub fn (mut ale AuditLogEntry) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'target_id' {
				ale.target_id = v.str()
			}
			'changes' {
				ale.changes = from_json_arr<AuditLogChange>(v.arr())
			}
			'user_id' {
				ale.user_id = v.str()
			}
			'id' {
				ale.id = v.str()
			}
			'action_type' {
				ale.action_type = AuditLogEvent(v.int())
			}
			'options' {
				ale.options = from_json<AuditEntryInfo>(v.as_map())
			}
			'reason' {
				ale.reason = v.str()
			}
			else {}
		}
	}
}

pub struct AuditLogChange {
pub mut:
	new_value json.Any [skip]
	old_value json.Any [skip]
	key       string // TODO: write module for managing audit log changes
}

pub fn (mut alc AuditLogChange) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'new_value' {
				alc.new_value = v
			}
			'old_value' {
				alc.old_value = v
			}
			'key' {
				alc.key = v.str()
			}
			else {}
		}
	}
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
pub mut:
	delete_member_days string
	members_removed    string
	channel_id         string
	message_id         string
	count              string
	id                 string
	@type              string
	role_name          string
}

pub fn (mut aei AuditEntryInfo) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'delete_member_days' {
				aei.delete_member_days = v.str()
			}
			'members_removed' {
				aei.members_removed = v.str()
			}
			'channel_id' {
				aei.channel_id = v.str()
			}
			'message_id' {
				aei.message_id = v.str()
			}
			'count' {
				aei.count = v.str()
			}
			'id' {
				aei.id = v.str()
			}
			'type' {
				aei.@type = v.str()
			}
			'role_name' {
				aei.role_name = v.str()
			}
			else {}
		}
	}
}

pub struct Activity {
pub mut:
	name           string
	@type          ActivityType
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

pub fn (mut activity Activity) from_json(f map[string]json.Any) {
	for k, v in f {
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
	end   int
}

pub fn (mut at ActivityTimestamp) from_json(f map[string]json.Any) {
	for k, v in f {
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
	id   string
	size [2]int
}

pub fn (mut ap ActivityParty) from_json(f map[string]json.Any) {
	for k, v in f {
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
	large_text  string
	small_image string
	small_text  string
}

pub fn (mut aa ActivityAssets) from_json(f map[string]json.Any) {
	for k, v in f {
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
	join     string
	spectate string
	@match   string
}

pub fn (mut ass ActivitySecrets) from_json(f map[string]json.Any) {
	for k, v in f {
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
	instance     = ActivityFlags(1 << 0)
	join         = ActivityFlags(1 << 1)
	spectate     = ActivityFlags(1 << 2)
	join_request = ActivityFlags(1 << 3)
	sync         = ActivityFlags(1 << 4)
	play         = ActivityFlags(1 << 5)
)

pub struct Attachment {
pub mut:
	id        string
	filename  string
	size      int
	url       string
	proxy_url string
	height    int
	width     int
}

pub fn (mut at Attachment) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { at.id = v.str() }
			'filename' { at.filename = v.str() }
			'size' { at.size = v.int() }
			'url' { at.url = v.str() }
			'proxy_url' { at.proxy_url = v.str() }
			'height' { at.height = v.int() }
			'width' { at.width = v.int() }
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
	for k, v in f {
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
	id       string
	guild_id string
	@type    ChannelType
	name     string
}

pub fn (mut cm ChannelMention) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { cm.id = v.str() }
			'guild_id' { cm.guild_id = v.str() }
			'type' { cm.@type = ChannelType(v.int()) }
			'name' { cm.name = v.str() }
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
	for k, v in f {
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

pub struct Message {
pub mut:
	id                 string
	channel_id         string
	guild_id           string
	author             User
	member             Member
	content            string
	timestamp          time.Time
	edited_timestamp   time.Time
	tts                bool
	mention_everyone   bool
	mentions           []User
	mention_roles      []string
	mention_channels   []ChannelMention
	attachments        []Attachment
	embeds             []Embed
	reactions          []Reaction
	nonce              string
	pinned             bool
	webhook_id         string
	@type              MessageType
	activity           MessageActivity
	application        MessageApplication
	message_reference  MessageReference
	referenced_message &Message = voidptr(0)
	stickers           []Sticker
	flags              MessageFlag
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
pub mut:
	@type    MessageActivityType
	party_id string
}

fn (mut m MessageActivity) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'type' { m.@type = MessageActivityType(v.int()) }
			'party_id' { m.party_id = v.str() }
			else {}
		}
	}
}

pub struct MessageApplication {
pub mut:
	id          string
	cover_image string
	description string
	icon        string
	name        string
}

fn (mut m MessageApplication) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { m.id = v.str() }
			'cover_image' { m.cover_image = v.str() }
			'description' { m.description = v.str() }
			'icon' { m.icon = v.str() }
			'name' { m.name = v.str() }
			else {}
		}
	}
}

// Contains reference data with crossposted messages
pub struct MessageReference {
pub mut:
	message_id string
	channel_id string
	guild_id   string
}

pub fn (mut m MessageReference) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'message_id' { m.message_id = v.str() }
			'channel_id' { m.channel_id = v.str() }
			'guild_id' { m.guild_id = v.str() }
			else {}
		}
	}
}

pub fn (m MessageReference) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['message_id'] = m.message_id
	obj['channel_id'] = m.channel_id
	obj['guild_id'] = m.guild_id
	return obj
}

fn (m MessageReference) iszero() bool {
	return m.to_json().str() == MessageReference{}.to_json().str()
}

pub enum StickerType {
	png = 1
	apng
	lottie
}

pub struct Sticker {
pub mut:
	id            string
	pack_id       string
	name          string
	description   string
	tags          string
	asset         string
	preview_asset string
	format_type   StickerType
}

pub fn (mut st Sticker) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { st.id = v.str() }
			'pack_id' { st.pack_id = v.str() }
			'name' { st.name = v.str() }
			'description' { st.description = v.str() }
			'tags' { st.tags = v.str() }
			'asset' { st.asset = v.str() }
			'preview_asset' { st.preview_asset = v.str() }
			'format_type' { st.format_type = StickerType(v.int()) }
			else {}
		}
	}
}

pub type MessageFlag = u8

pub const (
	crossposted            = MessageFlag(1 << 0)
	is_crosspost           = MessageFlag(1 << 1)
	suppress_embeds        = MessageFlag(1 << 2)
	source_message_deleted = MessageFlag(1 << 3)
	urgent                 = MessageFlag(1 << 4)
)

pub fn (mut m Message) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' {
				m.id = v.str()
			}
			'channel_id' {
				m.channel_id = v.str()
			}
			'guild_id' {
				m.guild_id = v.str()
			}
			'author' {
				m.author = from_json<User>(v.as_map())
			}
			'member' {
				m.member = from_json<Member>(v.as_map())
			}
			'content' {
				m.content = v.str()
			}
			'timestamp' {
				m.timestamp = time.parse_iso8601(v.str()) or { time.unix(0) }
			}
			'edited_timestamp' {
				m.edited_timestamp = time.parse_iso8601(v.str()) or { time.unix(0) }
			}
			'tts' {
				m.tts = v.bool()
			}
			'mention_everyone' {
				m.mention_everyone = v.bool()
			}
			'mentions' {
				m.mentions = from_json_arr<User>(v.arr())
			}
			'mention_roles' {
				mut obja := v.arr()
				for va in obja {
					m.mention_roles << va.str()
				}
			}
			'mention_channels' {
				m.mention_channels = from_json_arr<ChannelMention>(v.arr())
			}
			'attachments' {
				m.attachments = from_json_arr<Attachment>(v.arr())
			}
			'embeds' {
				m.embeds = from_json_arr<Embed>(v.arr())
			}
			'reaction' {
				m.reactions = from_json_arr<Reaction>(v.arr())
			}
			'nonce' {
				m.nonce = v.str()
			}
			'pinned' {
				m.pinned = v.bool()
			}
			'webhook_id' {
				m.webhook_id = v.str()
			}
			'type' {
				m.@type = MessageType(v.int())
			}
			'activity' {
				m.activity = from_json<MessageActivity>(v.as_map())
			}
			'application' {
				m.application = from_json<MessageApplication>(v.as_map())
			}
			'message_reference' {
				m.message_reference = from_json<MessageReference>(v.as_map())
			}
			'referenced_message' {
				mut ref := from_json<Message>(v.as_map())
				m.referenced_message = &ref
			}
			'stickers' {
				m.stickers = from_json_arr<Sticker>(v.arr())
			}
			'flags' {
				m.flags = MessageFlag(u8(v.int()))
			}
			else {}
		}
	}
}

pub struct Embed {
pub mut:
	title       string
	description string
	url         string
	timestamp   time.Time
	color       int
	footer      EmbedFooter
	image       EmbedImage
	thumbnail   EmbedThumbnail
	video       EmbedVideo
	provider    EmbedProvider
	author      EmbedAuthor
	fields      []EmbedField
}

pub fn (mut embed Embed) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'title' {
				embed.title = v.str()
			}
			'description' {
				embed.description = v.str()
			}
			'url' {
				embed.url = v.str()
			}
			'timestamp' {
				embed.timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'color' {
				embed.color = v.int()
			}
			'footer' {
				embed.footer = from_json<EmbedFooter>(v.as_map())
			}
			'image' {
				embed.image = from_json<EmbedImage>(v.as_map())
			}
			'thumbnail' {
				embed.thumbnail = from_json<EmbedThumbnail>(v.as_map())
			}
			'video' {
				embed.video = from_json<EmbedVideo>(v.as_map())
			}
			'provider' {
				embed.provider = from_json<EmbedProvider>(v.as_map())
			}
			'author' {
				embed.author = from_json<EmbedAuthor>(v.as_map())
			}
			'fields' {
				embed.image = from_json<EmbedImage>(v.as_map())
			}
			else {}
		}
	}
}

pub fn (mut embeds []Embed) from_json(f json.Any) {
	mut obj := f.arr()
	for embed in obj {
		mut e := Embed{}
		e.from_json(embed.as_map())
		embeds << e
	}
}

pub fn (embed Embed) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['title'] = embed.title
	obj['description'] = embed.description
	obj['color'] = embed.color
	obj['footer'] = embed.footer.to_json()
	obj['image'] = embed.image.to_json()
	obj['thumbnail'] = embed.thumbnail.to_json()
	obj['video'] = embed.video.to_json()
	obj['provider'] = embed.provider.to_json()
	obj['author'] = embed.author.to_json()
	obj['fields'] = embed.fields.to_json()
	return obj
}

pub fn (embed []Embed) to_json() json.Any {
	mut obj := []json.Any{}
	for e in embed {
		obj << e.to_json()
	}
	return obj
}

pub fn (embed Embed) iszero() bool {
	left := embed.to_json()
	right := Embed{}
	return left.str() == right.to_json().str()
}

pub struct EmbedFooter {
pub mut:
	text           string
	icon_url       string
	proxy_icon_url string
}

pub fn (mut ef EmbedFooter) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'text' { ef.text = v.str() }
			'icon_url' { ef.icon_url = v.str() }
			'proxy_icon_url' { ef.proxy_icon_url = v.str() }
			else {}
		}
	}
}

pub fn (ef EmbedFooter) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['text'] = ef.text
	obj['icon_url'] = ef.icon_url
	obj['proxy_icon_url'] = ef.proxy_icon_url
	return obj
}

pub fn (ef EmbedFooter) str() string {
	return ef.to_json().str()
}

pub struct EmbedImage {
pub mut:
	url       string
	proxy_url string
	height    int
	width     int
}

pub fn (mut ei EmbedImage) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'url' { ei.url = v.str() }
			'proxy_url' { ei.proxy_url = v.str() }
			'height' { ei.height = v.int() }
			'width' { ei.width = v.int() }
			else {}
		}
	}
}

pub fn (ei EmbedImage) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['url'] = ei.url
	obj['proxy_url'] = ei.proxy_url
	obj['height'] = ei.height
	obj['width'] = ei.width
	return obj
}

pub fn (ei EmbedImage) str() string {
	return ei.to_json().str()
}

pub struct EmbedThumbnail {
pub mut:
	url       string
	proxy_url string
	height    int
	width     int
}

pub fn (mut et EmbedThumbnail) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'url' { et.url = v.str() }
			'proxy_url' { et.proxy_url = v.str() }
			'height' { et.height = v.int() }
			'width' { et.width = v.int() }
			else {}
		}
	}
}

pub fn (et EmbedThumbnail) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['url'] = et.url
	obj['proxy_url'] = et.proxy_url
	obj['height'] = et.height
	obj['width'] = et.width
	return obj
}

pub fn (et EmbedThumbnail) str() string {
	return et.to_json().str()
}

pub struct EmbedVideo {
pub mut:
	url    string
	height int
	width  int
}

pub fn (mut ev EmbedVideo) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'url' { ev.url = v.str() }
			'height' { ev.height = v.int() }
			'width' { ev.width = v.int() }
			else {}
		}
	}
}

pub fn (ev EmbedVideo) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['url'] = ev.url
	obj['height'] = ev.height
	obj['width'] = ev.width
	return obj
}

pub fn (ev EmbedVideo) str() string {
	return ev.to_json().str()
}

pub struct EmbedProvider {
pub mut:
	name string
	url  string
}

pub fn (mut ep EmbedProvider) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'name' { ep.name = v.str() }
			'url' { ep.url = v.str() }
			else {}
		}
	}
}

pub fn (ep EmbedProvider) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['name'] = ep.name
	obj['url'] = ep.url
	return obj
}

pub fn (ep EmbedProvider) str() string {
	return ep.to_json().str()
}

pub struct EmbedAuthor {
pub mut:
	name           string
	url            string
	icon_url       string
	proxy_icon_url string
}

pub fn (mut ea EmbedAuthor) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'name' { ea.name = v.str() }
			'url' { ea.url = v.str() }
			'icon_url' { ea.icon_url = v.str() }
			'proxy_icon_url' { ea.proxy_icon_url = v.str() }
			else {}
		}
	}
}

pub fn (ea EmbedAuthor) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['name'] = ea.name
	obj['url'] = ea.url
	obj['icon_url'] = ea.icon_url
	obj['proxy_icon_url'] = ea.proxy_icon_url
	return obj
}

pub fn (ea EmbedAuthor) str() string {
	return ea.to_json().str()
}

pub struct EmbedField {
pub mut:
	name   string
	value  string
	inline bool
}

pub fn (mut ef EmbedField) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'name' { ef.name = v.str() }
			'value' { ef.value = v.str() }
			'inline' { ef.inline = v.bool() }
			else {}
		}
	}
}

pub fn (ef EmbedField) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['name'] = ef.name
	obj['value'] = ef.value
	obj['inline'] = ef.inline
	return obj
}

pub fn (ef []EmbedField) to_json() json.Any {
	mut obj := []json.Any{}
	for field in ef {
		obj << field.to_json()
	}
	return obj
}

pub fn (ef EmbedField) str() string {
	return ef.to_json().str()
}

pub struct Emoji {
pub mut:
	id    string
	name  string
	roles []Role
}

pub fn (mut emoji Emoji) from_json(f map[string]json.Any) {
	for k, v in f {
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
	data     []u8
}

pub struct UnavailableGuild {
pub mut:
	id          string
	unavailable bool
}

fn (mut g UnavailableGuild) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { g.id = v.str() }
			'unavailable' { g.unavailable = v.bool() }
			else {}
		}
	}
}

pub struct Member {
pub mut:
	user          User
	nick          string
	roles         []string
	joined_at     time.Time
	premium_since time.Time
	deaf          bool
	mute          bool
	pending       bool
}

pub fn (mut member Member) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'user' {
				member.user = from_json<User>(v.as_map())
			}
			'nick' {
				member.nick = v.str()
			}
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
			'deaf' {
				member.deaf = v.bool()
			}
			'mute' {
				member.mute = v.bool()
			}
			'pending' {
				member.pending = v.bool()
			}
			else {}
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
	for k, v in f {
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
	for k, v in f {
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
	user          User
	guild_id      string
	status        PresenceStatus
	activities    []Activity
	client_status PresenceClientStatus
}

pub fn (mut pu PresenceUpdate) from_json(f map[string]json.Any) {
	for k, v in f {
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
	idle    = PresenceStatus('idle')
	dnd     = PresenceStatus('dnd')
	online  = PresenceStatus('online')
	offline = PresenceStatus('offline')
)

pub struct PresenceClientStatus {
pub mut:
	desktop PresenceStatus = discordv.offline
	mobile  PresenceStatus = discordv.offline
	web     PresenceStatus = discordv.offline
}

pub fn (mut pcs PresenceClientStatus) from_json(f map[string]json.Any) {
	for k, v in f {
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
	joined_at                     time.Time
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
}

pub fn (mut guild Guild) from_json(f map[string]json.Any) {
	for k, v in f {
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
			'icon_hash' {
				guild.icon_hash = v.str()
			}
			'splash' {
				guild.splash = v.str()
			}
			'discovery_splash' {
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
pub mut:
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

pub fn (mut vs VoiceState) from_json(f map[string]json.Any) {
	for k, v in f {
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
	id         string
	name       string
	vip        bool
	optimal    bool
	deprecated bool
	custom     bool
}

pub fn (mut vr VoiceRegion) from_json(f map[string]json.Any) {
	for k, v in f {
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
	for k, v in f {
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
	hash string
}

pub fn (avatar Avatar) url() string {
	return 'https://cdn.discordapp.com/avatars/$avatar.user_id/{$avatar.hash}.png'
}

pub fn (avatar Avatar) str() string {
	return avatar.hash
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

pub fn (mut user User) from_json(f map[string]json.Any) {
	for k, v in f {
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
	if avatar := f['avatar'] {
		hash := avatar.str()
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

pub const (
	twitch  = IntegrationType('twitch')
	youtube = IntegrationType('youtube')
	discord = IntegrationType('discord')
)

pub struct IntegrationAccount {
pub mut:
	id   string
	name string
}

pub fn (mut iacc IntegrationAccount) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { iacc.id = v.str() }
			'name' { iacc.name = v.str() }
			else {}
		}
	}
}

pub struct IntegrationApplication {
pub mut:
	id          string
	name        string
	icon        string
	description string
	summary     string
	bot         User
}

pub fn (mut iapp IntegrationApplication) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' {
				iapp.id = v.str()
			}
			'name' {
				iapp.name = v.str()
			}
			'icon' {
				iapp.icon = v.str()
			}
			'description' {
				iapp.description = v.str()
			}
			'summary' {
				iapp.summary = v.str()
			}
			'bot' {
				iapp.bot = from_json<User>(v.as_map())
			}
			else {}
		}
	}
}

pub struct Integration {
pub mut:
	id                  string
	name                string
	@type               IntegrationType
	enabled             bool
	syncing             bool
	role_id             string
	enable_emoticons    bool
	expire_behavior     IntegrationExpireBehavior
	expire_grace_period int
	user                User
	account             IntegrationAccount
	synced_at           time.Time
	subscriber_count    int
	revoked             bool
	application         IntegrationApplication
}

pub fn (mut integration Integration) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' {
				integration.id = v.str()
			}
			'name' {
				integration.name = v.str()
			}
			'type' {
				integration.@type = IntegrationType(v.str())
			}
			'enabled' {
				integration.enabled = v.bool()
			}
			'syncing' {
				integration.syncing = v.bool()
			}
			'role_id' {
				integration.role_id = v.str()
			}
			'enable_emoticons' {
				integration.enable_emoticons = v.bool()
			}
			'expire_behavior' {
				integration.expire_behavior = IntegrationExpireBehavior(v.int())
			}
			'expire_grace_period' {
				integration.expire_grace_period = v.int()
			}
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
			'subscriber_count' {
				integration.subscriber_count = v.int()
			}
			'revoked' {
				integration.revoked = v.bool()
			}
			'application' {
				integration.application = from_json<IntegrationApplication>(v.as_map())
			}
			else {}
		}
	}
}

pub struct Interaction {
pub mut:
	id         string
	@type      InteractionType                   [json: 'type']
	data       ApplicationCommandInteractionData
	guild_id   string
	channel_id string
	member     Member
	token      string
	version    int
}

pub fn (mut inter Interaction) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { inter.id = v.str() }
			'type' { inter.@type = InteractionType(v.int()) }
			'data' { inter.data = from_json<ApplicationCommandInteractionData>(v.as_map()) }
			'guild_id' { inter.guild_id = v.str() }
			'channel_id' { inter.channel_id = v.str() }
			'member' { inter.member = from_json<Member>(v.as_map()) }
			'token' { inter.token = v.str() }
			'version' { inter.version = v.int() }
			else {}
		}
	}
}

pub enum InteractionType {
	ping = 1
	application_command = 2
}

pub struct ApplicationCommandInteractionData {
pub mut:
	id      string
	name    string
	options []&ApplicationCommandInteractionDataOption
}

pub fn (mut acid ApplicationCommandInteractionData) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' {
				acid.id = v.str()
			}
			'name' {
				acid.name = v.str()
			}
			'options' {
				mut arr := from_json_arr<ApplicationCommandInteractionDataOption>(v.arr())
				for mut item in arr {
					acid.options << item
				}
			}
			else {}
		}
	}
}

[heap]
pub struct ApplicationCommandInteractionDataOption {
pub mut:
	name    string
	value   string
	options []&ApplicationCommandInteractionDataOption
}

pub fn (mut acido ApplicationCommandInteractionDataOption) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'name' {
				acido.name = v.str()
			}
			'value' {
				acido.value = v.str()
			}
			'options' {
				mut arr := from_json_arr<ApplicationCommandInteractionDataOption>(v.arr())
				for item in arr {
					acido.options << &item
				}
			}
			else {}
		}
	}
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

pub fn (mut webhook Webhook) from_json(f map[string]json.Any) {
	for k, v in f {
		match k {
			'id' { webhook.id = v.str() }
			'type' { webhook.@type = WebhookType(v.int()) }
			'guild_id' { webhook.guild_id = v.str() }
			'channel_id' { webhook.channel_id = v.str() }
			'user' { webhook.user = from_json<User>(v.as_map()) }
			'name' { webhook.name = v.str() }
			'avatar' { webhook.avatar = v.str() }
			'token' { webhook.token = v.str() }
			'application_id' { webhook.application_id = v.str() }
			else {}
		}
	}
}

pub enum WebhookType {
	incoming = 1
	channel_follower
}

fn from_json<T>(f map[string]json.Any) T {
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
