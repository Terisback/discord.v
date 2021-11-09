module gateway

import time
import gateway.packets

// Handles hello from Websocket
fn (mut shard Shard) handle_hello(packet packets.Packet) {
	mut hello := packets.Hello{}
	hello.from_json(packet.data)
	shard.heartbeat_interval = hello.heartbeat_interval
	if shard.resuming {
		mut resume := packets.Resume{
			token: shard.token
			session_id: shard.session_id
			sequence: shard.sequence
		}
		message := packets.Packet{
			op: .resume
			data: resume.to_json_any()
		}.to_json()
		shard.ws.write_string(message) or { panic(err) }
		shard.resuming = false
	} else {
		message := packets.Packet{
			op: .identify
			data: packets.Identify{
				token: shard.token
				intents: shard.intents
				shard: [shard.id, shard.total_count]
			}.to_json_any()
		}.to_json()
		shard.ws.write_string(message) or { panic(err) }
	}
	shard.last_heartbeat = u64(time.now().unix_time_milli())
}

// Handles heartbeat_ack from Websocket
fn (mut shard Shard) handle_heartbeat_ack(packet packets.Packet) {
	shard.heartbeat_acked = true
}

// Handles invalid_session from Websocket
fn (mut shard Shard) handle_invalid_session(packet packets.Packet) {
	shard.resuming = packet.data.bool()
}
