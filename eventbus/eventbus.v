module eventbus

// discord.v event handler function
pub type EventHandlerFn = fn (client voidptr, event voidptr)

// Registry of event handlers
[heap]
struct Registry {
mut:
	events []EventHandler
}

struct EventHandler {
	name    string
	handler EventHandlerFn
}

// EventBus allows to subscribe and publish events
[heap]
pub struct EventBus {
pub mut:
	registry &Registry
}

// Create new EventBus
pub fn new() &EventBus {
	registry := &Registry{
		events: []EventHandler{}
	}
	return &EventBus{registry}
}

// Subscribe handler to event
pub fn (mut eb EventBus) subscribe(name string, handler EventHandlerFn) {
	eb.registry.events << EventHandler{
		name: name
		handler: handler
	}
}

// Unsubscribe handler from event
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

// Publish event
pub fn (mut eb EventBus) publish(name string, client voidptr, event voidptr) {
	for e in eb.registry.events {
		if e.name == name {
			e.handler(client, event)
		}
	}
}

// Clear all event handlers from registry
pub fn (mut eb EventBus) clear_all() {
	if eb.registry.events.len == 0 {
		return
	}
	for i := eb.registry.events.len - 1; i >= 0; i-- {
		eb.registry.events.delete(i)
	}
}

// Checks if any handler is subscribed to the event
pub fn (mut eb EventBus) has_subscriber(name string) bool {
	return eb.registry.check_subscriber(name)
}

// Checks if any handler is subscribed to the event in registry
fn (r &Registry) check_subscriber(name string) bool {
	for event in r.events {
		if event.name == name {
			return true
		}
	}
	return false
}
