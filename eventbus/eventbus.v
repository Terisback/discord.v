module eventbus

pub type EventHandlerFn = fn (client voidptr, event voidptr)

struct Registry {
mut:
	events []EventHandler
}

struct EventHandler {
	name string
	handler EventHandlerFn
}

pub struct EventBus {
pub mut:
	registry   &Registry
}

pub fn new() &EventBus {
	registry := &Registry{
		events: []
	}
	return &EventBus{
		registry,
	}
}

pub fn (mut eb EventBus) subscribe(name string, handler EventHandlerFn) {
	eb.registry.events << EventHandler {
		name: name
		handler: handler
	}
}

pub fn (mut eb EventBus) unsubscribe(name string, handler EventHandlerFn) {
	// v := voidptr(handler)
	for i, event in eb.registry.events {
		if event.name == name {
			if event.handler == handler {
				eb.registry.events.delete(i)
			}
		}
	}
}

pub fn (mut eb EventBus) publish(name string, client voidptr, event voidptr) {
	for e in eb.registry.events {
		if e.name == name {
			e.handler(client, event)
		}
	}
}

pub fn (mut eb EventBus) clear_all() {
	if eb.registry.events.len == 0 {
		return
	}
	for i := eb.registry.events.len - 1; i >= 0; i-- {
		eb.registry.events.delete(i)
	}
}

pub fn (mut eb EventBus) has_subscriber(name string) bool {
	return eb.registry.check_subscriber(name)
}

// Registry Methods
fn (r &Registry) check_subscriber(name string) bool {
	for event in r.events {
		if event.name == name {
			return true
		}
	}
	return false
}