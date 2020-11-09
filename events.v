module discordv

pub type EventHandler = fn(mut c Client, event voidptr)

pub enum Event {
	ready
}

const (
	event_list = {
		"ready": Ready{},
	}
)