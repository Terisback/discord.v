module packets

// Websocket Packet
pub struct Packet {
pub:
	op       Op     [json: op]
	sequence int    [json: s]
	event    string [json: t]
	data     string [json: d; raw]
}
