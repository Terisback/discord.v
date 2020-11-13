module client

import time
import discordv

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
			log('Unhandled event: $event_name')
		}
	}
}

fn (mut client Client) on_hello(packet GatewayPacket){
	mut hello := discordv.Hello{}
	hello.from_json(packet.data)
	client.heartbeat_interval = hello.heartbeat_interval
	message := IdentifyPacket{
		d: Identify{
			token: client.token
			intents: client.intents
			shard: [client.shard_id, client.shard_count]
		}
	}.to_json()
	client.ws.write_str(message)
	client.last_heartbeat = time.now().unix_time_milli()
	client.events.publish('hello', client, hello)
}

fn (mut client Client) on_heartbeat_ack(packet GatewayPacket){
	client.heartbeat_acked = true
}

fn (mut client Client) on_invalid_session(packet GatewayPacket){
    resumable := packet.data.bool()
	if resumable {
		message := ResumePacket{
			op: Op.resume
			data: Resume{
				token: client.token
				session_id: client.session_id
				sequence: client.sequence
			}
		}.to_json()
		client.ws.write_str(message)
	}else{
		log('Asking for reconnect...')
		go client.reconnect()
	}
}

fn (mut client Client) reconnect() {
	client.reconnect <- true
}

fn (mut client Client) start_heartbeat() ? {
	for {
		select {
			_ := <- client.stop {
				return
			}
			_ := <- client.reconnect {
				client.ws.connect()?
				go client.ws.listen()?
			}
			> time.millisecond {
				if time.now().unix_time_milli() - client.last_heartbeat > client.heartbeat_interval {
					if client.heartbeat_acked != true {
						log('Asking for reconnect...')
						go client.reconnect()
						continue
					}
					heartbeat := HeartbeatPacket {
						op: Op.heartbeat,
						data: client.sequence
					}
					message := heartbeat.to_json()
					client.ws.write(message.bytes(), .text_frame)
					client.last_heartbeat = time.now().unix_time_milli()
					client.heartbeat_acked = false
				}
			}
		}
	}
}