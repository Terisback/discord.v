module snowflake

import time

// discord_epoch is Discord's epoch in milliseconds
pub const (
	discord_epoch = u64(1420070400000)
)

// Snowflake is the type for a Discord snowflake
pub struct Snowflake {
pub:
	id                  u64
	increment           u64
	internal_process_id u64
	internal_worker_id  u64
}

// Creates a new snowflake
pub fn new_snowflake(id u64) Snowflake {
	return Snowflake{
		id: id
		increment: id & 0xFFF
		internal_process_id: (id & 0x1F000) >> 12
		internal_worker_id: (id & 0x3E0000) >> 17
	}
}

// Gets the snowflake as an i64
pub fn (s Snowflake) i64() i64 {
	return i64(s.id)
}

// Gets the snowflake as a string
pub fn (s Snowflake) str() string {
	return s.id.str()
}

// Converts the snowflake to a time.Time object
pub fn (s Snowflake) time() time.Time {
	return time.unix(int(((s.id >> 22) + discord_epoch) / 1000))
}

pub fn (s Snowflake) is_nil() bool{
	return s.id == 0
}