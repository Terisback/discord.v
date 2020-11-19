module client

import discordv
import discordv.gateway
import discordv.util

fn on_dispatch(mut client &Client, packet gateway.Packet){
	event_name := packet.event.to_lower()
	match event_name {
		'hello' { 
			mut obj := discordv.Hello{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		 }
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

// fn publish<T>(mut client Client, event_name string, data json.Any){
// 	mut obj := T{}
// 	obj.from_json(data)
// 	client.events.publish(event_name, client, obj)
// }