module gateway

import time
import json
import gateway.packets

// Handles hello from Websocket
fn (mut shard Shard) handle_hello(packet packets.Packet) {
	hello := json.decode(packets.Hello, packet.data) or {
		// shard log error
		return
	}
	shard.heartbeat_interval = hello.heartbeat_interval
	if shard.resuming {
		message := packets.Packet{
			op: .resume
			data: json.encode(packets.Resume{
				token: shard.token
				session_id: shard.session_id
				sequence: shard.sequence
			})
		}
		shard.ws.write_string(json.encode(message)) or { panic(err) }
		shard.resuming = false
	} else {
		message := packets.Packet{
			op: .identify
			data: json.encode(packets.Identify{
				token: shard.token
				intents: shard.intents
				shard: [shard.id, shard.total_count]
			})
		}
		shard.ws.write_string(json.encode(message)) or { panic(err) }
	}
	shard.last_heartbeat = time.now().unix_time_milli()
}

// Handles heartbeat_ack from Websocket
fn (mut shard Shard) handle_heartbeat_ack(packet packets.Packet) {
	shard.heartbeat_acked = true
}

// Handles invalid_session from Websocket
fn (mut shard Shard) handle_invalid_session(packet packets.Packet) {
	shard.resuming = packet.data.bool()
}

fn (mut shard Shard) handle_reconnect(packet packets.Packet) {
	shard.resuming = true
	shard.ws.close(int(CloseCode.normal_closure), 'Reconnect') or {
		shard.log.info('#$shard.id Unhandled opcode: ${int(packet.op)} ($packet.op)')
	}
}
