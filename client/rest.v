module client

import net.http
import x.json2 as json
import discordv.structs as st

const (
	api = 'https://discord.com/api/v8'
)

pub fn (mut client Client) get_shard_count() ?int {
	mut req := http.new_request(.get, api + '/gateway/bot', '')?
	req.add_header('Authorization', 'Bot $client.token') 
	resp := req.do()?
	if resp.status_code != 200 {
		return error('Status code is $resp.status_code')
	}

	mut res := json.raw_decode(resp.text)?
	return res.as_map()['shards'].int()
}

pub fn (mut client Client) create_message(channel_id string, message st.Message) ? {
	mut req := http.new_request(.post, api + '/channels/$channel_id/messages', '')?
	req.add_header('Authorization', 'Bot $client.token') 
	// do message jsonify
	resp := req.do()?
	if resp.status_code != 200 {
		return error('Status code is $resp.status_code')
	}
}