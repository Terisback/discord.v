module discordv

import discordv.gateway.packets
import discordv.util

pub type Dispatch = packets.Packet
pub type Hello = packets.Hello
pub type MessageCreate = Message
pub type MessageUpdate = Message
pub type MessageDelete = Message

fn on_hello(mut client &Client, hello &packets.Hello){
	client.events.publish('hello', client, hello)
}

fn on_dispatch(mut client &Client, packet &packets.Packet){
	event_name := packet.event.to_lower()
	client.events.publish('dispatch', client, packet)
	match event_name {
		'ready' { 
			mut obj := Ready{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_create' { 
			mut obj := MessageCreate{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_update' { 
			mut obj := MessageUpdate{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		'message_delete' { 
			mut obj := MessageDelete{}
			obj.from_json(packet.data)
			client.events.publish(event_name, client, obj)
		}
		else {
			util.log('Unhandled event: $event_name')
		}
	}
}

pub fn (mut client Client) on_dispatch(handler fn(mut client &Client, event &Dispatch)){
	client.events.subscribe('dispatch', handler)
}

pub fn (mut client Client) on_hello(handler fn(mut client &Client, event &Hello)){
	client.events.subscribe('hello', handler)
}

pub fn (mut client Client) on_ready(handler fn(mut client &Client, event &Ready)){
	client.events.subscribe('ready', handler)
}

pub fn (mut client Client) on_message_create(handler fn(mut client &Client, event &MessageCreate)){
	client.events.subscribe('message_create', handler)
}

pub fn (mut client Client) on_message_update(handler fn(mut client &Client, event &MessageUpdate)){
	client.events.subscribe('message_update', handler)
}

pub fn (mut client Client) on_message_delete(handler fn(mut client &Client, event &MessageDelete)){
	client.events.subscribe('message_delete', handler)
}