module packets

// Websocket Op Codes
pub enum Op {
	dispatch
	heartbeat
	identify
	presence_update
	voice_state_update
	five_undocumented
	resume
	reconnect
	request_guild_members
	invalid_session
	hello
	heartbeat_ack
}
