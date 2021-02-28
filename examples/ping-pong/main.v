module main

import os
import discordv

fn main() {
	// Getting token from env variable
	token := os.getenv('BOT_TOKEN')
	if token == '' {
		println('Please provide bot token via environment variable BOT_TOKEN')
		return
	}
	// Creating new client
	mut client := discordv.new_client(token: token) ?
	// Add message create handler
	client.on_message_create(on_ping)
	// Open connection and wait till close
	client.open() ?
}

// Ping handler
fn on_ping(mut client discordv.Client, evt &discordv.MessageCreate) {
	// If content of message is '!ping' reply with 'pong!'
	if evt.content == '!ping' {
		// Send message to channel
		client.channel_message_send(evt.channel_id, content: 'pong!') or { }
	}
}
