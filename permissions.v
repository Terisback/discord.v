module discordv

pub type Permission = int

pub struct Permissions {
pub:
	create_instant_invite Permission = Permission(0x00000001)
	kick_members          Permission = Permission(0x00000002)
	ban_members           Permission = Permission(0x00000004)
	administrator         Permission = Permission(0x00000008)
	manage_channels       Permission = Permission(0x00000010)
	manage_guild          Permission = Permission(0x00000020)
	add_reactions         Permission = Permission(0x00000040)
	view_audit_log        Permission = Permission(0x00000080)
	priority_speaker      Permission = Permission(0x00000100)
	stream                Permission = Permission(0x00000200)
	view_channel          Permission = Permission(0x00000400)
	send_messages         Permission = Permission(0x00000800)
	send_tts_messages     Permission = Permission(0x00001000)
	manage_messages       Permission = Permission(0x00002000)
	embed_links           Permission = Permission(0x00004000)
	attach_files          Permission = Permission(0x00008000)
	read_message_history  Permission = Permission(0x00010000)
	mention_everyone      Permission = Permission(0x00020000)
	use_external_emojis   Permission = Permission(0x00040000)
	view_guild_insights   Permission = Permission(0x00080000)
	connect               Permission = Permission(0x00100000)
	speak                 Permission = Permission(0x00200000)
	mute_members          Permission = Permission(0x00400000)
	deafen_members        Permission = Permission(0x00800000)
	move_members          Permission = Permission(0x01000000)
	use_vad               Permission = Permission(0x02000000)
	change_nickname       Permission = Permission(0x04000000)
	manage_nicknames      Permission = Permission(0x08000000)
	manage_roles          Permission = Permission(0x10000000)
	manage_webhooks       Permission = Permission(0x20000000)
	manage_emojis         Permission = Permission(0x40000000)
}

pub const (
	permissions = Permissions{}
)
