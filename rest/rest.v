module rest

import discordv.util
import net.http
import sync
import time

pub struct REST {
pub:
	token string
mut:
	rl &RateLimit
}

pub fn new(token string) &REST{
	return &REST{
		token: token
		rl: &RateLimit{}
	}
}

pub fn (mut rest REST) do(req http.Request) ?http.Response {
	bucket := req.url
	mut mlock := rest.rl.m_lock(bucket)
	resp := req.do()?
	if resp.status_code == 429 {
		retry_after := resp.lheaders['retry-after'].int()
		if 'x-ratelimit-global' in resp.lheaders && resp.lheaders['x-ratelimit-global'] == 'true' {
			util.log('rate limit: global, retrying in $retry_after seconds.')
			rest.rl.global_lock.m_lock()
			time.sleep(retry_after)
			rest.rl.global_lock.unlock()
		} else {
			util.log('rate limit: $bucket, retrying in $retry_after seconds.')
			time.sleep(retry_after)
		}
		mlock.unlock()
		return rest.do(req)
	} else {
		if resp.lheaders['x-ratelimit-remaining'] == '0' {
			reset_after := int(resp.lheaders['x-ratelimit-reset-after'].f64() + 1)
			util.log('exhausted bucket: $bucket, will reset in $reset_after seconds.')
			go fn (mut m sync.Mutex, s int) {
				time.sleep(s)
				m.unlock()
			}(mut mlock, reset_after)
		} else {
			mlock.unlock()
		}
	}
	return resp
}