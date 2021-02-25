module gateway

import time
import discordv.gateway.packets

fn (mut conn Connection) hello(packet packets.Packet) {
	mut hello := packets.Hello{}
	hello.from_json(packet.data)
	conn.heartbeat_interval = hello.heartbeat_interval
	if conn.resuming {
		mut resume := packets.Resume{
			token: conn.token
			session_id: conn.session_id
			sequence: conn.sequence
		}
		message := packets.Packet{
			op: .resume
			data: resume.to_json_any()
		}.to_json()
		conn.ws.write_str(message) or { panic(err) }
		conn.resuming = false
	} else {
		message := packets.Packet{
			op: .identify
			data: packets.Identify{
				token: conn.token
				intents: conn.intents
				shard: [conn.shard_id, conn.shard_count]
			}.to_json_any()
		}.to_json()
		conn.ws.write_str(message) or {panic(err)}
		conn.publish('hello', &hello)
	}
	conn.last_heartbeat = time.now().unix_time_milli()
}

// Handles heartbeat_ack from Websocket
fn (mut conn Connection) heartbeat_ack(packet packets.Packet) {
	conn.heartbeat_acked = true
}

// Handles invalid_session from Websocket
fn (mut conn Connection) invalid_session(packet packets.Packet) {
	conn.resuming = packet.data.bool()
}

// Run heartbeat loop. Will execute till stop signal recieved
fn (mut conn Connection) run_heartbeat() ? {
	for {
		mut stop := false
		status := conn.stop.try_pop(stop)
		if status == .success {
			conn.ws.close(1000, 'close() was called')?
			return
		}
		time.wait(50 * time.millisecond)
		if conn.ws.state in [.connecting, .closing, .closed] {
			continue
		}
		now := time.now().unix_time_milli()
		if now - conn.last_heartbeat > conn.heartbeat_interval {
			if conn.heartbeat_acked != true {
				if conn.ws.state == .open {
					conn.ws.close(1000, "heartbeat ack didn't come") or {
						panic(err)
					}
				}
				continue
			}
			heartbeat := packets.Packet{
				op: .heartbeat
				data: conn.sequence
			}
			message := heartbeat.to_json()
			conn.ws.write_str(message) or { conn.log.error('Something went wrong with websocket: $err') }
			conn.last_heartbeat = now
			conn.heartbeat_acked = false
		}
	}
}
