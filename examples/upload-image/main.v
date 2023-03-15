module main

import os
import discordv as vd

fn main() {
	// Getting token from env variable
	token := os.getenv('BOT_TOKEN')
	if token == '' {
		println('Please provide bot token via environment variable BOT_TOKEN')
		return
	}
	// Read image
	image := os.read_bytes(os.dir(os.executable()) + '/v_logo.png')!
	// Creating new client
	mut client := vd.new(token: token)!
	// Add image as userdata
	client.userdata = &image
	// Add message create handler
	client.on_message_create(img)
	// Open connection and wait till close
	client.run().wait()
}

// Image sender
fn img(mut client vd.Client, evt &vd.MessageCreate) {
	// If content of message is '!image' reply with image
	if evt.content == '!image' {
		// Send image to channel
		client.channel_message_send(evt.channel_id,
			file: vd.File{
				filename: 'v-logo.png'
				data: &[]u8(client.userdata)
			}
		) or {}
	}
}
