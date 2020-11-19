module gateway

import time
import discordv
import discordv.util

enum Op {
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

fn (mut conn Connection) dispatch(packet Packet) {
	conn.dispatch_handler(conn.dispatch_receiver, packet)
}

fn (mut conn Connection) on_hello(packet Packet) {
	mut hello := discordv.Hello{}
	hello.from_json(packet.data)
	conn.heartbeat_interval = hello.heartbeat_interval
	if conn.resuming {
		message := Packet{
			op: .resume
			data: Resume{
				token: conn.token
				session_id: conn.session_id
				sequence: conn.sequence
			}.to_json_any()
		}.to_json()
		conn.ws.write_str(message)
		conn.resuming = false
	} else {
		message := Packet{
			op: .identify
			data: Identify{
				token: conn.token
				intents: conn.intents
				shard: [conn.shard_id, conn.shard_count]
			}.to_json_any()
		}.to_json()
		conn.ws.write_str(message)
	}
	conn.last_heartbeat = time.now().unix_time_milli()
}

fn (mut conn Connection) on_heartbeat_ack(packet Packet) {
	conn.heartbeat_acked = true
}

fn (mut conn Connection) on_invalid_session(packet Packet) {
	conn.resuming = packet.data.bool()
}

fn (mut conn Connection) run_heartbeat() ? {
	for {
		// Think about stop with select if it needed
		time.sleep_ms(50)
		if conn.ws.state in [.connecting, .closing, .closed] {
			continue
		}
		now := time.now().unix_time_milli()
		if now - conn.last_heartbeat > conn.heartbeat_interval {
			if conn.heartbeat_acked != true {
				if conn.ws.state == .open {
					conn.ws.close(1000, "Heartbeat ack didn't come")
				}
				continue
			}
			heartbeat := Packet{
				op: .heartbeat
				data: conn.sequence
			}
			message := heartbeat.to_json()
			conn.ws.write_str(message) or {
				util.log('Something went wrong: $err')
			}
			conn.last_heartbeat = now
			conn.heartbeat_acked = false
		}
	}
}