module rest

import sync
import time
import x.json2 as json
import discordv.util.modum

struct RateLimiter {
pub mut:
	mutex &sync.Mutex = sync.new_mutex()
	global modum.Modum
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
	now := modum.now()
	if bucket.remaining < min_remaining && bucket.reset.after(now){
		return bucket.reset.sub(now)
	}

	if now.before(rl.global) {
		return rl.global.sub(now)
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
	reset modum.Modum
}

pub fn (mut bucket Bucket) release(headers map[string]string) {
	defer {bucket.mutex.unlock()}

	if headers.len == 0 {
		return 
	}

	if 'retry-after' in headers {
		retry_after := headers['retry-after'].i64()
		reset_at := modum.now().add(retry_after)
		if 'x-ratelimit-global' in headers {
			bucket.rl.global = headers['x-ratelimit-global'].i64()
		} else {
			bucket.reset = reset_at
		}
	} else if 'x-ratelimit-reset' in headers && 'date' in headers {
		date := time.parse_iso8601(headers['date']) or {
			return 
		}
		discord_time := modum.from_v(date)
		unix := modum.Modum(headers['x-ratelimit-reset'].i64() * 1000)
		delta := unix.sub(discord_time) + 250 // 250 is a magic number
		bucket.reset = modum.now().add(delta)
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