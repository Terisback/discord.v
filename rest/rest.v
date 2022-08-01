module rest

import net.http
import time
import x.json2 as json

const (
	api            = 'https://discord.com/api/v8'
	bot_user_agent = 'DiscordBot (https://github.com/Terisback/discord.v, v0.1.0)'
)

// REST struct allows making requests to api with rate limiting
pub struct REST {
pub:
	token string
mut:
	rl &RateLimiter
}

// Create new REST manager
pub fn new(token string) &REST {
	return &REST{
		token: token
		rl: &RateLimiter{}
	}
}

// Create new discord api request
pub fn new_request(token string, method http.Method, path string) ?http.Request {
	mut req := http.new_request(method, rest.api + path, '') ?
	req.add_header(.authorization, 'Bot $token')
	req.add_header(.user_agent, rest.bot_user_agent)
	return req
}

// Create new discord api request
pub fn (mut rst REST) req(method http.Method, path string) ?http.Request {
	mut req := http.new_request(method, rest.api + path, '') ?
	req.add_header(.authorization, 'Bot $rst.token')
	req.add_header(.user_agent, rest.bot_user_agent)
	return req
}

// Make a request taking into account the rate limits
pub fn (mut rst REST) do(req http.Request) ?http.Response {
	key := req.url
	mut bucket := rst.rl.lock_bucket(key)
	resp := req.do() or {
		bucket.mutex.unlock()
		return err
	}
	bucket.release(resp.header)
	if resp.status_code == 429 {
		mut obj := json.raw_decode(resp.body.replace('\n', '')) or { panic(err) }
		mut tmr := TooManyRequests{}
		tmr.from_json(obj)
		rst.rl.global = u64(time.utc().unix_time_milli()) + u64(tmr.retry_after) * 1000
		time.sleep(i64(tmr.retry_after) * 1000 * time.millisecond)
		return rst.do(req)
	}
	return resp
}

// REST API Error Message
struct ApiErrorMessage {
	code    int
	errors  json.Any
	message string
}

// Rest Api Response Codes
enum ResponseCode {
	ok = 200
	created = 201
	no_content = 204
	not_modified = 304
	bad_request = 400
	unauthorized = 401
	forbidden = 403
	not_found = 404
	method_not_allowed = 405
	too_many_requests = 429
	gateway_unavailable = 502
}
