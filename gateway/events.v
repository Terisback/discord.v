module gateway

import discordv.gateway.packets

pub fn (mut conn Connection) on_hello(handler fn(reciever voidptr, hello &packets.Hello)) {
	conn.events.subscribe('hello', handler)
}

pub fn (mut conn Connection) on_dispatch(handler fn(reciever voidptr, dispatch &packets.Packet)) {
	conn.events.subscribe('dispatch', handler)
}

pub fn (mut conn Connection) set_reciever(reciever voidptr) {
	conn.reciever = reciever
}

fn (mut conn Connection) publish(event string, data voidptr){
	if conn.reciever != voidptr(0) {
		conn.events.publish(event, conn.reciever, data)
	} else {
		conn.events.publish(event, conn, data)
	}
}