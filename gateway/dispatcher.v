module gateway

import eb

pub struct DispatchArgs {
pub:
	reciever voidptr
	data     voidptr
}

[heap]
pub struct Dispatcher {
	packages chan DispatchArgs
mut:
	event_bus &eb.EventBus
}

pub fn new_dispatcher(event_bus &eb.EventBus, packages chan DispatchArgs) &Dispatcher {
	return &Dispatcher{
		event_bus: event_bus
		packages: packages
	}
}

pub fn (mut d Dispatcher) run() {
	if d.packages.closed {
		return
	}

	go d.loop()
}

pub fn (mut d Dispatcher) stop() {
	d.packages.close()
}

fn (mut d Dispatcher) loop() {
	for {
		args := <-d.packages or { break }

		d.event_bus.publish('dispatch', args.reciever, args.data)
	}
}
