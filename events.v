module discordv

import discordv.gateway.packets
import discordv.util

pub type Dispatch = packets.Packet
pub type Hello = packets.Hello
pub type MessageCreate = Message
pub type MessageUpdate = Message
pub type MessageDelete = Message
struct GuildMemberAdd {
	pub mut:
		member Member
		guild_id string
}

// Publishing hello event to client eventbus
fn on_hello(mut client &Client, hello &packets.Hello){
	client.events.publish('hello', client, hello)
}

// Deals with packets from gateway. Publishing to client eventbus
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
		'guild_member_add' {
			mut obj := GuildMemberAdd{}
			obj.member.from_json(packet.data)
			mut data := packet.data.as_map()
			obj.guild_id = data['guild_id'].str()
			client.events.publish(event_name, client, obj)
		}
		else {
			util.log('Unhandled event: $event_name')
		}
	}
}

// Add event handler to Dispatch event
pub fn (mut client Client) on_dispatch(handler fn(mut client &Client, event &Dispatch)){
	client.events.subscribe('dispatch', handler)
}

// Add event handler to Hello event
pub fn (mut client Client) on_hello(handler fn(mut client &Client, event &Hello)){
	client.events.subscribe('hello', handler)
}

// Add event handler to Ready event
pub fn (mut client Client) on_ready(handler fn(mut client &Client, event &Ready)){
	client.events.subscribe('ready', handler)
}

// Add event handler to MessageCreate event
pub fn (mut client Client) on_message_create(handler fn(mut client &Client, event &MessageCreate)){
	client.events.subscribe('message_create', handler)
}

// Add event handler to MessageUpdate event
pub fn (mut client Client) on_message_update(handler fn(mut client &Client, event &MessageUpdate)){
	client.events.subscribe('message_update', handler)
}

// Add event handler to MessageDelete event
pub fn (mut client Client) on_message_delete(handler fn(mut client &Client, event &MessageDelete)){
	client.events.subscribe('message_delete', handler)
}

// Add event handler to GuildMemberAdd event
pub fn (mut client Client) on_guild_member_add(handler fn(mut client &Client, event &GuildMemberAdd)){
	client.events.subscribe('guild_member_add', handler)
}
