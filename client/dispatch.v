module client

import discordv
import discordv.gateway.packets
import discordv.util

fn on_dispatch(mut client &Client, packet packets.Packet){
	event_name := packet.event.to_lower()
	client.events.publish('dispatch', client, packet)
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
		'reconnect' { 
			mut obj := discordv.Reconnect{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_create' { 
			mut obj := discordv.MessageCreate{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_update' { 
			mut obj := discordv.MessageUpdate{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_delete' { 
			mut obj := discordv.MessageDelete{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		else {
			util.log('Unhandled event: $event_name')
		}
	}
}

// It will wait till generic support for foreign types modules implement
// fn publish<T>(mut client Client, event_name string, data json.Any){
// 	mut obj := T{}
// 	obj.from_json(data)
// 	client.events.publish(event_name, client, obj)
// }