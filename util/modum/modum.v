module modum

import time

// Sometimes you just need a primitive measure on which you will rely
//
// Modum is a millisecond alias
pub type Modum = i64

pub fn now() Modum{
	return Modum(i64(time.now().unix_time_milli()))
}

// Get Modum from time.Time
pub fn from_v(s time.Time) Modum{
	return Modum(i64(s.unix_time_milli()))
}

pub fn (t Modum) since(s Modum) Modum {
	return s - t
}

pub fn (t Modum) before(s Modum) bool {
	return t < s
}

pub fn (t Modum) after(s Modum) bool {
	return t > s
}

pub fn (t Modum) add(s Modum) Modum {
	return t + s
}

pub fn (t Modum) sub(s Modum) Modum {
	return t - s
}
