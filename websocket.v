module discordv

import x.json2 as json
import x.websocket

fn ws_on_open(mut ws websocket.Client, mut c &Client) ? {
	println('[discord.v] Successfully connected to gateway')
}

fn ws_on_error(mut ws websocket.Client, error string, mut c &Client) ? {
	println('[discord.v] Gateway error: $error')
}

fn ws_on_message(mut ws websocket.Client, msg &websocket.Message, mut c &Client) ? {
	match msg.opcode {
		.text_frame {
			packet := json.decode<GatewayPacket>(msg.payload.bytestr())
			c.sequence = packet.sequence
			match Op(packet.op){
				.dispatch { c.on_dispatch(packet) }
				.hello { c.on_hello(packet) }
				.heartbeat_ack { c.on_heartbeat_ack(packet) }
				else {
					thing := Op(packet.op)
					println('[discord.v] Unhandled opcode: $packet.op ($thing)')
				}
			}
		}
		else {
			println('[discord.v] Unhandled websocket opcode: $msg.opcode')
		}
	}
}

fn ws_on_close(mut ws websocket.Client, code int, reason string, mut c &Client) ? {
	println('[discord.v] Gateway closed, code $code, reason: $reason')
}