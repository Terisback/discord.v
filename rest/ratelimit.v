module rest

import sync
import time
import net.http
import x.json2 as json

[heap]
struct RateLimiter {
pub mut:
	mutex   &sync.Mutex = sync.new_mutex()
	global  u64
	buckets map[string]&Bucket = map[string]&Bucket{}
}

// Creates new RateLimiter
pub fn new_ratelimiter() &RateLimiter {
	return &RateLimiter{}
}

// Get bucket by key
pub fn (mut rl RateLimiter) get_bucket(key string) &Bucket {
	rl.mutex.@lock()
	defer {
		rl.mutex.unlock()
	}
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

// Get bucket wait time
pub fn (mut rl RateLimiter) get_wait_time(bucket &Bucket, min_remaining int) u64 {
	now := time.utc().unix_time_milli() // TODO: check if abs(system time - discord time) > 2
	if now < rl.global {
		return rl.global - now
	}
	if bucket.remaining < min_remaining && bucket.reset > now {
		return bucket.reset - now
	}
	return 0
}

// Lock bucket by key before do a request
pub fn (mut rl RateLimiter) lock_bucket(key string) &Bucket {
	mut bucket := rl.get_bucket(key)
	return rl.lock_bucket_obj(mut bucket)
}

// Lock bucket before do a request
pub fn (mut rl RateLimiter) lock_bucket_obj(mut bucket Bucket) &Bucket {
	bucket.mutex.@lock()
	wait := rl.get_wait_time(bucket, 1)
	if wait > 0 {
		time.sleep(i64(wait) * time.millisecond)
	}
	bucket.remaining--
	return bucket
}

// Bucket is needed to control the number of requests up to a certain endpoint
[heap]
struct Bucket {
pub mut:
	rl        &RateLimiter
	mutex     &sync.Mutex = sync.new_mutex()
	remaining int
	limit     int
	reset     u64
}

// Update bucket limits from responce headers
pub fn (mut bucket Bucket) release(header http.Header) {
	defer {
		bucket.mutex.unlock()
	}
	if header.keys().len == 0 {
		return
	}
	if header.contains_custom("x-ratelimit-reset") {
		bucket.reset = u64((header.get_custom("x-ratelimit-reset") or { return err }).f64() * 1000)
	}
	if header.contains_custom("x-ratelimit-remaining") {
		bucket.remaining = (header.get_custom("x-ratelimit-remaining") or { return err }).int()
	}
}

// REST API error (TODO: Move to errors.v)
struct TooManyRequests {
pub mut:
	message     string
	retry_after f32
	global      bool
}

pub fn (mut tmr TooManyRequests) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj {
		match k {
			'message' { tmr.message = v.str() }
			'retry_after' { tmr.retry_after = v.f32() }
			'global' { tmr.global = v.bool() }
			else {}
		}
	}
}
