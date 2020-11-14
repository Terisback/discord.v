module client

import time
import discordv
import discordv.util

fn (mut client Client) on_dispatch(packet GatewayPacket){
	event_name := packet.event.to_lower()
	match event_name {
		'ready' {
			mut obj := discordv.Ready{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_create' {
			mut obj := discordv.MessageCreate{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		else {
			util.log('Unhandled event: $event_name')
		}
	}
}

fn (mut client Client) on_hello(packet GatewayPacket){
	mut hello := discordv.Hello{}
	hello.from_json(packet.data)
	client.heartbeat_interval = hello.heartbeat_interval
	if client.resuming {
		message := ResumePacket{
			data: Resume{
				token: client.token
				session_id: client.session_id
				sequence: client.sequence
			}
		}.to_json()
		client.ws.write_str(message)
		client.resuming = false
	} else {
		message := IdentifyPacket{
			d: Identify{
				token: client.token
				intents: client.intents
				shard: [client.shard_id, client.shard_count]
			}
		}.to_json()
		client.ws.write_str(message)
	}
	client.last_heartbeat = time.now().unix_time_milli()
	client.events.publish('hello', client, hello)
}

fn (mut client Client) on_heartbeat_ack(packet GatewayPacket){
	client.heartbeat_acked = true
}

fn (mut client Client) on_invalid_session(packet GatewayPacket){
    resumable := packet.data.bool()
	client.reconnect <- resumable
}