module discordv

import discordv.rest
import discordv.rest.formdata
import discordv.util

type Payload = File | Message | string //| Embed

// Send message to channel
pub fn (mut client Client) send(channel_id string, message Payload) ? {
	mut req := rest.new_request(client.token, .post, '/channels/$channel_id/messages') ?
	mut form := formdata.new() ?
	req.add_header('Content-Type', form.content_type())
	match message {
		string {
			payload := Message{
				content: message
			}.outbound_json()
			form.add('payload_json', payload)
		}
		Message {
			form.add('payload_json', message.outbound_json())
		}
		File {
			form.add_file('file', message.filename, message.data)
			payload := Message{
				content: 'hi'
			}.outbound_json()
			form.add('payload_json', payload)
		}
	}
	req.data = form.encode()
	resp := client.rest.do(req) ?
	if resp.status_code != 200 {
		response_error := rest.ResponseCode(resp.status_code)
		err_text := 'Status code is $resp.status_code ($response_error)'
		util.log(err_text)
		return error(err_text)
	}
}
