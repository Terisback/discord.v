module discordv

import discordv.rest
import discordv.rest.formdata
import discordv.util

type Payload = File | Message | string | Embed

// Send message to channel
pub fn (mut client Client) send(channel_id string, message Payload) ? {
	mut req := rest.new_request(client.token, .post, '/channels/$channel_id/messages') ?
	match message {
		string {
			req.add_header('Content-Type', 'application/json')
			payload := Message{
				content: message
			}.to_json().str()
			req.data = payload
		}
		Message {
			req.add_header('Content-Type', 'application/json')
			req.data = message.to_json().str()
		}
		File {
			mut form := formdata.new() ?
			req.add_header('Content-Type', form.content_type())
			form.add_file('file', message.filename, message.data)
			req.data = form.encode()
		}
		Embed {
			req.add_header('Content-Type', 'application/json')
			data := message.to_json()
			payload := '{"embed":$data}'
			req.data = payload
		}
	}
	
	resp := client.rest.do(req) ?
	if resp.status_code != 200 {
		response_error := rest.ResponseCode(resp.status_code)
		err_text := 'Status code is $resp.status_code ($response_error).\n'
		util.log(err_text + 'Request: $req.data')
		return error(err_text)
	}
}
