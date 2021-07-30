module main

import os
import json
import Terisback.discordv

fn main() {
	// Getting token from env variable
	token := os.getenv('BOT_TOKEN')
	if token == '' {
		println('Please provide bot token via environment variable BOT_TOKEN')
		return
	}
	config := discordv.Config{
		token: token
	}
	// Creating new client
	mut client := discordv.new(config)
	// Add message create handler
	client.on_message_create(on_ping)
	// Open connection and wait till close
	client.run().wait()
}

// Ping handler
fn on_ping(mut client discordv.Client, evt &discordv.MessageCreate) {
	// If content of message is '!ping' reply with 'pong!'
	if evt.content == '!ping' {
		// Send message to channel
		client.channel_message_send(evt.channel_id, content: 'pong!') or {}

		al := client.guild_audit_log(evt.guild_id, limit: 16) or {
			client.channel_message_send(evt.channel_id, content: 'something went wrong') or {}
			return
		}

		mut txt := json.encode_pretty(al)

		if txt.len > 2000 {
			txt = txt[..2000]
		}

		client.channel_message_send(evt.channel_id, content: txt) or {}
	}
}
