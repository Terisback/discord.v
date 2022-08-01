module main

import os
import terisback.discordv as vd

fn main() {
	// Getting token from env variable
	token := os.getenv('BOT_TOKEN')
	if token == '' {
		println('Please provide bot token via environment variable BOT_TOKEN')
		return
	}
	// Creating new client
	mut client := vd.new(token: token)?
	// Add message create handler
	client.on_message_create(reply_with_embed)
	// Open connection and wait till close
	client.run().wait()
}

fn reply_with_embed(mut client vd.Client, evt &vd.MessageCreate) {
	if evt.content == '!repo' {
		client.channel_message_send(evt.channel_id,
			embed: vd.Embed{
				title: 'V UI'
				description: 'Example embed, all kinds of fields should work. Feel free to be free)'
				image: vd.EmbedImage{
					url: 'https://raw.githubusercontent.com/vlang/ui/master/examples/screenshot.png'
				}
				fields: [
					vd.EmbedField{
						name: 'Repo link:'
						value: '[Github Repo](https://github.com/vlang/ui)'
						inline: true
					},
					vd.EmbedField{
						name: 'Vlang Repo:'
						value: '**Vlang** [*Repo*](https://github.com/vlang/v)'
						inline: true
					},
				]
				color: 0x5f9be6 // V Color
			}
		) or {}
	}
}
