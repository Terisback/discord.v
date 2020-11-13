module discordv

import x.json2 as json
import x.websocket

fn ws_on_open(mut ws websocket.Client, mut s &Shard) ? {
	log('Successfully connected to gateway [shard_id:$s.shard_id]')
}

fn ws_on_error(mut ws websocket.Client, error string, mut s &Shard) ? {
	log('Gateway error: $error')
}

fn ws_on_message(mut ws websocket.Client, msg &websocket.Message, mut s &Shard) ? {
	match msg.opcode {
		.text_frame {
			packet := json.decode<GatewayPacket>(msg.payload.bytestr())
			s.sequence = packet.sequence
			match Op(packet.op){
				.dispatch { s.on_dispatch(packet) }
				.hello { s.on_hello(packet) }
				.heartbeat_ack { s.on_heartbeat_ack(packet) }
				.invalid_session { s.on_invalid_session(packet) }
				.reconnect { s.ws.close(GatewayCloseErrorCode.unknown, 'Asking for reconnect from outside') }
				else {
					thing := Op(packet.op)
					log('Unhandled opcode: $packet.op ($thing)')
				}
			}
		}
		else {
			log('Unhandled websocket opcode: $msg.opcode')
		}
	}
}

fn ws_on_close(mut ws websocket.Client, code int, reason string, mut s &Shard) ? {
	error := GatewayCloseErrorCode(code)
	match error {
		1000 {
			log('Gateway successfully closed [shard_id: $s.shard_id, code: $error, reason: $reason]')
			log('Stopping shard... [shard_id: $s.shard_id]')
			s.stop <- true
		}
		else {
			log('Gateway closed [shard_id: $s.shard_id, code: $error, reason: $reason]')
			log('Going to reconnect to gateway... [shard_id: $s.shard_id]')
			s.reconnect <- true
		}
	}
}

enum GatewayCloseErrorCode {
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