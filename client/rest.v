module client

import x.json2 as json
import discordv.rest
import discordv.rest.formdata
import discordv.structs as st

pub fn (mut client Client) get_shard_count() ?int {
	mut req := rest.new_request(client.token, .get, '/gateway/bot')?
	resp := client.rest.do(req)?
	if resp.status_code != 200 {
		return error('Status code is $resp.status_code')
	}

	mut res := json.raw_decode(resp.text)?
	return res.as_map()['shards'].int()
}

// add embed
type Message = string | st.Message | st.File

// aka creaate message
pub fn (mut client Client) send(channel_id string, message Message) ? {
	mut req := rest.new_request(client.token, .post, '/channels/$channel_id/messages')?
	mut form := formdata.new()?
	req.add_header('Content-Type', form.content_type())
	match message {
		string {
			payload := st.Message{ content: message }.outbound_json()
			form.add('payload_json', payload) 
		}
		st.Message { form.add('payload_json', message.outbound_json()) }
		st.File {
			form.add_file('file', message.filename, message.data)
			payload := st.Message{ content: 'hi' }.outbound_json()
			form.add('payload_json', payload)
		}
	}
	
	req.data = form.encode()
	resp := client.rest.do(req)?
	if resp.status_code != 200 {
		println(resp.text)
		response_error := RestResponseCode(resp.status_code)
		return error('Status code is $resp.status_code ($response_error)')
	}
}