module discordv

import discordv.rest
import discordv.rest.formdata
import discordv.util

// // Get recommended shard count
// pub fn (mut client Client) get_shard_count() ?int {
// 	mut req := rest.new_request(client.token, .get, '/gateway/bot')?
// 	resp := client.rest.do(req)?
// 	if resp.status_code != 200 {
// 		return error('Status code is $resp.status_code')
// 	}

// 	mut res := json.raw_decode(resp.text)?
// 	return res.as_map()['shards'].int()
// }

// add embed
type Payload = string | Message | File //| Embed

// aka create message
pub fn (mut client Client) send(channel_id string, message Payload) ? {
	mut req := rest.new_request(client.token, .post, '/channels/$channel_id/messages')?
	mut form := formdata.new()?
	req.add_header('Content-Type', form.content_type())
	match message {
		string {
			payload := Message{ content: message }.outbound_json()
			form.add('payload_json', payload) 
		}
		Message { form.add('payload_json', message.outbound_json()) }
		File {
			form.add_file('file', message.filename, message.data)
			payload := Message{ content: 'hi' }.outbound_json()
			form.add('payload_json', payload)
		}
	}
	
	req.data = form.encode()
	resp := client.rest.do(req)?
	if resp.status_code != 200 {
		response_error := rest.ResponseCode(resp.status_code)
		err_text := 'Status code is $resp.status_code ($response_error)'
		util.log(err_text)
		return error(err_text)
	}
}