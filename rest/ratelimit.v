module rest

import sync
import time

struct RateLimit {
pub mut:
	rw &sync.RwMutex = sync.new_rwmutex() // TODO: remove when maps are thread-safe
	buckets map[string]&sync.Mutex = map[string]&sync.Mutex{}
	global_lock &sync.Mutex = sync.new_mutex()
}

fn (mut rl RateLimit) m_lock(bucket string) &sync.Mutex {
	// TODO: uncomment when pr merged vlang/v#7003
	//if !rl.global_lock.try_lock() {
		rl.global_lock.m_lock()
	//}
	rl.global_lock.unlock()
	rl.rw.r_lock()
	if bucket !in rl.buckets {
		rl.rw.r_unlock()
		mut mlock := sync.new_mutex()
		rl.rw.w_lock()
		rl.buckets[bucket] = mlock
		mlock.m_lock()
		rl.rw.w_unlock()
		return mlock
	} else {
		mut mlock := rl.buckets[bucket]
		rl.rw.r_unlock()
		mlock.m_lock()
		return mlock
	}
}

fn (mut rl RateLimit) unlock(bucket string) {
	rl.rw.r_lock()
	rl.buckets[bucket].unlock()
	rl.rw.r_unlock()
}