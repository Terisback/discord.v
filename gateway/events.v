module gateway

import gateway.packets

// Add packet handler to Dispatch packet
pub fn (mut shard Shard) on_dispatch(handler fn(reciever voidptr, dispatch &packets.Packet)) {
	shard.events.subscribe('dispatch', handler)
}

// Set reciever, it will provided as first argument to dispatch handlers
pub fn (mut shard Shard) set_reciever(reciever voidptr) {
	shard.reciever = reciever
}