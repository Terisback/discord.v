module gateway

import term
import x.json2 as json
import x.websocket
import discordv.gateway.packets
import discordv.util

// Handles open event for Websocket
fn on_open(mut ws websocket.Client, mut conn Connection) ? {
	util.log(term.bright_green('#$conn.shard_id Successfully connected to gateway'))
}

// Handles error event for Websocket
fn on_error(mut ws websocket.Client, error string, mut conn Connection) ? {
	util.log(term.bright_red('#$conn.shard_id Gateway error: $error'))
}

// Handles message event for Websocket
fn on_message(mut ws websocket.Client, msg &websocket.Message, mut conn Connection) ? {
	match msg.opcode {
		.text_frame {
			mut obj := json.raw_decode(msg.payload.bytestr())?
			mut packet := packets.Packet{}
			packet.from_json(obj)
			conn.sequence = packet.sequence	
			match packets.Op(packet.op){
				.dispatch { conn.publish('dispatch', &packet) }
				.hello { conn.hello(packet) }
				.heartbeat_ack { conn.heartbeat_ack(packet) }
				.invalid_session { conn.invalid_session(packet) }
				.reconnect { 
					conn.resuming = true
					conn.ws.close(CloseCode.normal_closure, "Reconnect") 
				}
				else {
					thing := packets.Op(packet.op)
					util.log('#$conn.shard_id Unhandled opcode: $packet.op ($thing)')
				}
			}
		}
		else {
			util.log('#$conn.shard_id Unhandled websocket opcode: $msg.opcode')
		}
	}
}

// Handles close event for Websocket
fn on_close(mut ws websocket.Client, code int, reason string, mut conn Connection) ? {
	error := CloseCode(code)
	util.log(term.bright_yellow('#$conn.shard_id Gateway closed [code: $code ($error), reason: $reason]'))
}

// Websocket close codes
enum CloseCode {
	normal_closure = 1000
	unknown = 4000
	unknown_opcode = 4001
	decode_error = 4002
	not_authenticated = 4003
	authentication_failed = 4004
	already_authenticated = 4005
	invalid_sequence = 4007
	rate_limited = 4008
	session_timed_out = 4009
	invalid_shard = 4010
	sharding_required = 4011
	invalid_api_version = 4012
	invalid_intents = 4013
	disallowed_intents = 4014
}