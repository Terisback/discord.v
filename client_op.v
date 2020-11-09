module discordv

import time

fn (mut c Client) on_dispatch(packet GatewayPacket){
	event_name := packet.event.to_lower()
	if event_name !in event_list {
		println('[discord.v] Unhandled event -> $packet.event.to_lower()')
		return
	}
	mut obj := event_list[event_name]
	obj.from_json(packet.data)
	for handler in c.events[event_name]{
		handler(mut c, obj)
	}
}

fn (mut c Client) on_hello(packet GatewayPacket){
	mut hello := HelloPacket{}
	hello.from_json(packet.data)
	c.heartbeat_interval = hello.heartbeat_interval
	message := IdentifyPacket{
		d: Identify{
			token: c.token
			intents: 7
		}
	}.to_json()
	c.ws.write_str(message)
	c.last_heartbeat = time.now().unix
}

fn (mut c Client) on_heartbeat_ack(packet GatewayPacket){
	if c.heartbeat_asked {
		return
	}
	heartbeat := HeartbeatPacket {
		op: Op.heartbeat,
		data: c.sequence
	}
	println("[discord.v] Heartbeat ask $c.sequence")
	message := heartbeat.to_json()
	println(message)
	c.ws.write_str(message)
	c.heartbeat_asked = true
}