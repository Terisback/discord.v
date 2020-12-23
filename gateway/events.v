module gateway

import discordv.gateway.packets

// Add packet handler to Hello packet
pub fn (mut conn Connection) on_hello(handler fn(reciever voidptr, hello &packets.Hello)) {
	conn.events.subscribe('hello', handler)
}

// Add packet handler to Dispatch packet
pub fn (mut conn Connection) on_dispatch(handler fn(reciever voidptr, dispatch &packets.Packet)) {
	conn.events.subscribe('dispatch', handler)
}

// Set reciever, it will provided as first argument to packet handlers
pub fn (mut conn Connection) set_reciever(reciever voidptr) {
	conn.reciever = reciever
}

// Publish packet to eventbus
fn (mut conn Connection) publish(event string, data voidptr){
	if conn.reciever != voidptr(0) {
		conn.events.publish(event, conn.reciever, data)
	} else {
		conn.events.publish(event, conn, data)
	}
}