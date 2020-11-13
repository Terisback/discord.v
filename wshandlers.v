module discordv

import time

fn (mut s Shard) on_dispatch(packet GatewayPacket){
	event_name := packet.event.to_lower()
	match event_name {
		'ready' {
			mut obj := Ready{}
			obj.from_json(packet.data)
			s.client.events.publish(event_name, s.client, obj)
		}
		'message_create' {
			mut obj := MessageCreate{}
			obj.from_json(packet.data)
			s.client.events.publish(event_name, s.client, obj)
		}
		else {
			log('Unhandled event: $event_name')
		}
	}
}

fn (mut s Shard) on_hello(packet GatewayPacket){
	mut hello := Hello{}
	hello.from_json(packet.data)
	s.heartbeat_interval = hello.heartbeat_interval
	message := IdentifyPacket{
		d: Identify{
			token: s.client.token
			intents: s.client.intents
			shard: [s.shard_id, s.client.shards.len]
		}
	}.to_json()
	s.ws.write_str(message)
	s.last_heartbeat = time.now().unix_time_milli()
	s.client.events.publish('hello', s.client, hello)
}

fn (mut s Shard) on_heartbeat_ack(packet GatewayPacket){
	s.heartbeat_acked = true
}

fn (mut s Shard) on_invalid_session(packet GatewayPacket){
    resumable := packet.data.bool()
	if resumable {
		message := ResumePacket{
			op: Op.resume
			data: Resume{
				token: s.client.token
				session_id: s.session_id
				sequence: s.sequence
			}
		}.to_json()
		s.ws.write_str(message)
	}else{
		s.ws.close(GatewayCloseErrorCode.unknown, 'Asking for reconnect from inside')
	}
}

fn (mut s Shard) start_heartbeat(){
	for {
		select {
			_ := <- s.stop {
				s.client.wg.done()	
				log("stoppidy")
				return
			}
			_ := <- s.reconnect {
				log("Getting ready to recc")
				s.ws.connect() or {
					log('Can\'t reconnect, $err')
					continue
				}
				go s.ws.listen() or {
					log('PANIC $err')
					s.stop <- true
				}
			}
			> time.millisecond {
				if time.now().unix_time_milli() - s.last_heartbeat > s.heartbeat_interval {
					if s.heartbeat_acked != true {
						log('Asking for reconnect...')
						s.ws.close(GatewayCloseErrorCode.unknown, 'Asking for reconnect from inside')
						continue
					}
					heartbeat := HeartbeatPacket {
						op: Op.heartbeat,
						data: s.sequence
					}
					message := heartbeat.to_json()
					s.ws.write(message.bytes(), .text_frame)
					s.last_heartbeat = time.now().unix_time_milli()
					s.heartbeat_acked = false
				}
			}
		}
	}
}