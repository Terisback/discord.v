module client

import x.json2 as json
import x.websocket

fn ws_on_open(mut ws websocket.Client, mut client &Client) ? {
	log('Successfully connected to gateway [shard_id:$client.shard_id]')
}

fn ws_on_error(mut ws websocket.Client, error string, mut client &Client) ? {
	log('Gateway error: $error')
}

fn ws_on_message(mut ws websocket.Client, msg &websocket.Message, mut client &Client) ? {
	match msg.opcode {
		.text_frame {
			packet := json.decode<GatewayPacket>(msg.payload.bytestr())
			client.sequence = packet.sequence
			match Op(packet.op){
				.dispatch { client.on_dispatch(packet) }
				.hello { client.on_hello(packet) }
				.heartbeat_ack { client.on_heartbeat_ack(packet) }
				.invalid_session { client.on_invalid_session(packet) }
				.reconnect { client.ws.close(GatewayCloseErrorCode.unknown, 'Asking for reconnect from outside') }
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

fn ws_on_close(mut ws websocket.Client, code int, reason string, mut client &Client) ? {
	error := GatewayCloseErrorCode(code)
	match error {
		.unknown, .unknown_opcode, .invalid_sequence {
			log('Gateway closed [shard_id: $client.shard_id, code: $error, reason: $reason]')
			log('Going to reconnect to gateway... [shard_id: $client.shard_id]')
			client.reconnect <- true
		}
		else {
			log('Gateway successfully closed [shard_id: $client.shard_id, code: $error, reason: $reason]')
			log('Stopping shard... [shard_id: $client.shard_id]')
			client.stop <- true
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