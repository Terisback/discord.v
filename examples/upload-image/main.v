module main

import os
import discordv as vd
// Our local module that contains image bytes
import binary 

fn main() {
	// Getting token from env variable
	token := os.getenv('BOT_TOKEN')
	if token == '' {
		println('Please provide bot token via environment variable BOT_TOKEN')
		return
	}
	// Creating new client
	mut client := vd.new(token: token) ?
	// Add message create handler
	client.on_message_create(img)
	// Open connection and wait till close
	client.open() ?
}

// Image sender
fn img(mut client vd.Client, evt &vd.MessageCreate) {
	// If content of message is '!image' reply with image
	if evt.content == '!image' {
		// Send image to channel
		client.send(evt.channel_id, vd.File{
			filename: 'v-logo.png'
			// You can embed image as i did, but you can do it at runtime `os.read_file()` etc.
			data: binary.v_logo_png[0..binary.v_logo_png_len]
		}) or { }
	}
}
