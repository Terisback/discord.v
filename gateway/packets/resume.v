module packets

// Websocket Resume packet data
pub struct Resume {
pub:
	token      string
	session_id string
	sequence   int    [json: seq]
}
