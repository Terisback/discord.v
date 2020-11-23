module discordv

import discordv.types

pub struct Permissions {
pub:
	create_instant_invite types.Permission = types.Permission(0x00000001)
	kick_members          types.Permission = types.Permission(0x00000002)
	ban_members           types.Permission = types.Permission(0x00000004)
	administrator         types.Permission = types.Permission(0x00000008)
	manage_channels       types.Permission = types.Permission(0x00000010)
	manage_guild          types.Permission = types.Permission(0x00000020)
	add_reactions         types.Permission = types.Permission(0x00000040)
	view_audit_log        types.Permission = types.Permission(0x00000080)
	priority_speaker      types.Permission = types.Permission(0x00000100)
	stream                types.Permission = types.Permission(0x00000200)
	view_channel          types.Permission = types.Permission(0x00000400)
	send_messages         types.Permission = types.Permission(0x00000800)
	send_tts_messages     types.Permission = types.Permission(0x00001000)
	manage_messages       types.Permission = types.Permission(0x00002000)
	embed_links           types.Permission = types.Permission(0x00004000)
	attach_files          types.Permission = types.Permission(0x00008000)
	read_message_history  types.Permission = types.Permission(0x00010000)
	mention_everyone      types.Permission = types.Permission(0x00020000)
	use_external_emojis   types.Permission = types.Permission(0x00040000)
	view_guild_insights   types.Permission = types.Permission(0x00080000)
	connect               types.Permission = types.Permission(0x00100000)
	speak                 types.Permission = types.Permission(0x00200000)
	mute_members          types.Permission = types.Permission(0x00400000)
	deafen_members        types.Permission = types.Permission(0x00800000)
	move_members          types.Permission = types.Permission(0x01000000)
	use_vad               types.Permission = types.Permission(0x02000000)
	change_nickname       types.Permission = types.Permission(0x04000000)
	manage_nicknames      types.Permission = types.Permission(0x08000000)
	manage_roles          types.Permission = types.Permission(0x10000000)
	manage_webhooks       types.Permission = types.Permission(0x20000000)
	manage_emojis         types.Permission = types.Permission(0x40000000)
}

pub const (
	permissions = Permissions{}
)
