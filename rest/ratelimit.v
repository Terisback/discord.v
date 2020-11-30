module rest

import sync
import time
import x.json2 as json
import discordv.util.modum

struct RateLimiter {
pub mut:
	mutex &sync.Mutex = sync.new_mutex()
	global u64
	buckets map[string]&Bucket = map[string]&Bucket{}
}

pub fn new_ratelimiter() &RateLimiter {
	return &RateLimiter{}
}

pub fn (mut rl RateLimiter) get_bucket(key string) &Bucket {
	rl.mutex.m_lock()
	defer {rl.mutex.unlock()}

	if key in rl.buckets {
		return rl.buckets[key]
	}

	bucket := &Bucket{
		rl: rl
		remaining: 1
	}

	rl.buckets[key] = bucket
	return bucket
}

pub fn (mut rl RateLimiter) get_wait_time(bucket &Bucket, min_remaining int) modum.Modum {
	now := time.utc().unix_time_milli()  // TODO: check if abs(system time - discord time) > 2
	if now < rl.global {
		return rl.global - now
	}

	if bucket.remaining < min_remaining && bucket.reset > now {
		return bucket.reset - now
	}

	return 0
}

pub fn (mut rl RateLimiter) lock_bucket(key string) &Bucket {
	mut bucket := rl.get_bucket(key)
	return rl.lock_bucket_obj(mut bucket)
}

pub fn (mut rl RateLimiter) lock_bucket_obj(mut bucket &Bucket) &Bucket{
	bucket.mutex.m_lock()

	wait := rl.get_wait_time(bucket, 1)
	if wait > 0 {
		time.sleep_ms(wait)
	}

	bucket.remaining--
	return bucket
}

struct Bucket {
pub mut:
	rl &RateLimiter
	mutex &sync.Mutex = sync.new_mutex()
	remaining int
	limit int
	reset u64
}

pub fn (mut bucket Bucket) release(headers map[string]string) {
	defer {bucket.mutex.unlock()}

	if headers.len == 0 {
		return 
	}

	if 'x-ratelimit-reset' in headers {
		bucket.reset = u64(headers['x-ratelimit-reset'].f64() * 1000)
	}

	if 'x-ratelimit-remaining' in headers {
		bucket.remaining = headers['x-ratelimit-remaining'].int()
	}
}

struct TooManyRequests {
pub mut:
	message string
	retry_after f32
	global bool
}

pub fn (mut tmr TooManyRequests) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'message' {tmr.message = v.str()}
			'retry_after' {tmr.retry_after = v.f32()}
			'global' {tmr.global = v.bool()}
			else {}
		}
	}
}
