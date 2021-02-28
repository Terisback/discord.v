module rest

import net.http
import time
import x.json2 as json

// REST struct allows making requests to api with rate limiting
pub struct REST {
pub:
	token string
mut:
	rl    &RateLimiter
}

// Create new REST manager
pub fn new(token string) &REST {
	return &REST{
		token: token
		rl: &RateLimiter{}
	}
}

// Make a request taking into account the rate limits
pub fn (mut rest REST) do(req http.Request) ?http.Response {
	key := req.url
	mut bucket := rest.rl.lock_bucket(key)
	resp := req.do() or {
		bucket.release(map[string]string{})
		return error(err)
	}
	bucket.release(resp.lheaders)
	if resp.status_code == 429 {
		eprintln('warn: ratelimited')
		mut obj := json.raw_decode(resp.text) ?
		mut tmr := TooManyRequests{}
		tmr.from_json(obj)
		rest.rl.global = time.utc().unix_time_milli() + u64(tmr.retry_after) * 1000
		time.sleep(i64(tmr.retry_after) * 1000 * time.millisecond)
		return rest.do(req)
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
