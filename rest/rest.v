module rest

import discordv.util
import net.http
import sync
import time
import x.json2 as json

pub struct REST {
pub:
	token string
mut:
	rl &RateLimiter
}

pub fn new(token string) &REST{
	return &REST{
		token: token
		rl: &RateLimiter{}
	}
}

pub fn (mut rest REST) do(req http.Request) ?http.Response {
	key := req.url
	mut bucket := rest.rl.lock_bucket(key)
	resp := req.do() or {
		bucket.release(map[string]string{})
		return error(err)
	}
	bucket.release(resp.lheaders)
	if resp.status_code == 429 {
		mut obj := json.raw_decode(resp.text)?
		mut tmr := TooManyRequests{}
		tmr.from_json(obj)
		time.sleep_ms(int(tmr.retry_after))
		return rest.do(req)
	}
	return resp
}