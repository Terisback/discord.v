module packets

import x.json2 as json

// Websocket Resume packet data
pub struct Resume {
pub:
	token      string
	session_id string
	sequence   int
}

pub fn (d Resume) to_json_any() json.Any {
	mut resume := map[string]json.Any{}
	resume['token'] = d.token
	resume['session_id'] = d.session_id
	resume['seq'] = d.sequence
	return resume
}
