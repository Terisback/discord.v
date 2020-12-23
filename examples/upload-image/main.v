module main

import os
import discordv as vd

fn main(){
	// Getting token from env variable
	token := os.getenv('BOT_TOKEN')
	if token == '' {
		println('Please provide bot token via environment variable BOT_TOKEN')
		return
	}

	// Creating new client
    mut client := vd.new(vd.Config{token: token})?
	
	// Add message create handler
    client.on_message_create(img)

	// Open connection and wait till close
    client.open()?
}

// Image sender
fn img(mut client &vd.Client, evt &vd.MessageCreate){
	// If content of message is '!image' reply with image
    if evt.content == '!image' {
		// Read image file to string
		image := os.read_file('./v-logo.png') or {
			println('Error then reading image. $err')
			return
		}
		// Send image to channel
        client.send(evt.channel_id, vd.File{
			filename: 'v-logo.png'
			data: image.bytes()
		}) or {}
    }
}