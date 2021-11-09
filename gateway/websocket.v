module gateway

import x.json2 as json
import net.websocket
import gateway.packets

// Handles open event for Websocket
fn on_open(mut ws websocket.Client, mut shard Shard) ? {
	shard.log.info('#$shard.id Successfully connected to gateway')
}

// Handles error event for Websocket
fn on_error(mut ws websocket.Client, error string, mut shard Shard) ? {
	shard.log.error('#$shard.id Gateway error: $error')
}

// Handles message event for Websocket
fn on_message(mut ws websocket.Client, msg &websocket.Message, mut shard Shard) ? {
	match msg.opcode {
		.text_frame {
			mut obj := json.raw_decode(msg.payload.bytestr()) ?
			mut packet := packets.Packet{}
			packet.from_json(obj)
			shard.sequence = packet.sequence
			match packets.Op(packet.op) {
				.dispatch {
					shard.dispatch(&packet)
				}
				.hello {
					shard.handle_hello(packet)
				}
				.heartbeat_ack {
					shard.handle_heartbeat_ack(packet)
				}
				.invalid_session {
					shard.handle_invalid_session(packet)
				}
				.reconnect {
					shard.resuming = true
					shard.ws.close(int(CloseCode.normal_closure), 'Reconnect') ?
				}
				else {
					thing := packets.Op(packet.op)
					shard.log.info('#$shard.id Unhandled opcode: $packet.op ($thing)')
				}
			}
		}
		else {
			shard.log.info('#$shard.id Unhandled websocket opcode: $msg.opcode')
		}
	}
}

// Handles close event for Websocket
fn on_close(mut ws websocket.Client, code int, reason string, mut shard Shard) ? {
	error := CloseCode(code)
	shard.log.warn('#$shard.id Gateway closed [code: $code ($error), reason: $reason]')
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
