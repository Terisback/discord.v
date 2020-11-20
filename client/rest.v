module client

import net.http
import x.json2 as json
import discordv.structs as st

const (
	api = 'https://discord.com/api/v8'
	bot_user_agent = 'DiscordBot (https://github.com/Terisback/discord.v, v0.0.1)'
)

fn (mut client Client) new_request(method http.Method, path string) ?http.Request {
	mut req := http.new_request(method, api + path, '')?
	req.add_header('Authorization', 'Bot $client.token') 
	req.add_header('User-Agent', bot_user_agent)
	req.add_header('Content-Type', 'application/json')
	return req
}

pub fn (mut client Client) get_shard_count() ?int {
	mut req := client.new_request(.get, '/gateway/bot')?
	resp := req.do()?
	if resp.status_code != 200 {
		return error('Status code is $resp.status_code')
	}

	mut res := json.raw_decode(resp.text)?
	return res.as_map()['shards'].int()
}

// add embed
type Message = int | string | st.Message

// aka creaate message
pub fn (mut client Client) send(channel_id string, message Message) ? {
	mut req := client.new_request(.post, '/channels/$channel_id/messages')?
	match message {
		int {
			outbound := st.Message{
				content: message.str()
			}.outbound_json()
			req.data = outbound
			resp := req.do()?
			if resp.status_code != 200 {
				return error('Status code is $resp.status_code')
			}
			return
		}
		string {
			outbound := st.Message{
				content: message
			}.outbound_json()
			req.data = outbound
			resp := req.do()?
			if resp.status_code != 200 {
				return error('Status code is $resp.status_code')
			}
			return
		}
		st.Message {
			outbound := message.outbound_json()
			req.data = outbound
			resp := req.do()?
			if resp.status_code != 200 {
				return error('Status code is $resp.status_code')
			}
			return
		}
	}
	panic('not reachable, maybe you passing empty Message{}')
}