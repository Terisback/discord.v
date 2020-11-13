module rest

import net.http
import x.json2 as json

const (
	api = 'https://discord.com/api/v8'
)

fn (mut c Client) get_shard_count() ?int {
	mut req := http.new_request(.get, api + '/gateway/bot', '')?
	req.add_header('Authorization', 'Bot $c.token') 
	resp := req.do()?
	if resp.status_code != 200 {
		return error('Status code is $resp.status_code')
	}

	mut res := json.raw_decode(resp.text)?
	return res.as_map()['shards'].int()
}