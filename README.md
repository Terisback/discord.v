![discord.v](https://user-images.githubusercontent.com/26527529/98575853-c348d300-22ca-11eb-86f6-d22cc9b1e0cf.png)

#  

<p align="center">
Yet another feature-rich Discord Bot Framework written in V <i>(Big <b>WIP</b>)</i><br>
<a href="https://discordv.terisback.ru/discordv.html">
  <img src="https://img.shields.io/badge/docs-2F3136?style=flat&logo=v">
</a>
</p>

## Example

```v
import discordv as vd

fn main() {
	mut client := vd.new(token: 'token') ?
	client.on_message_create(on_ping)
	client.open() ?
}

fn on_ping(mut client vd.Client, evt &vd.MessageCreate) {
	if evt.content == '!ping' {
		client.send(evt.channel_id, 'pong!') or { }
	}
}
```

## How to install

*discord.v* uses openssl-dev, be sure it is installed `apt install openssl-dev`  
> Only way to run it on Windows is to use WSL (or install openssl-dev somehow)  

```bash
git clone https://github.com/Terisback/discord.v.git ~/.vmodule/discordv
```

And then import `discordv` wherever you like

## TODO()

### First milestone
- [x] Connect to gateway
- [x] Handle heartbeat
- [x] Event system (pub/sub)
- [x] REST for sending messages
- [x] Implement `multipart/form-data` for file sending
- [ ] Do usual `application/json` for sending without binary data
- [ ] Implement all structs
  - [ ] Audit Log
  - [ ] Channel
  - [ ] Emoji
  - [ ] Guild
  - [ ] Invite
  - [x] User
  - [ ] Voice
  - [ ] Webhook
  - [ ] Slash Command
- [ ] Create more examples
- [ ] Documentation

### Second milestone
- [ ] Handle REST
  - [ ] Audit Log
  - [ ] Channel
  - [ ] Emoji
  - [ ] Guild
  - [ ] Invite
  - [ ] User
  - [ ] Voice
  - [ ] Webhook
  - [ ] Slash Command
  - [x] Observe rate limits (thanks to @div72)
- [ ] Slash Commands
- [ ] Fancy log
- [ ] Command router
- [ ] Think about tests

### Third milestone (till V v0.3)
- [ ] Translate dispatch to generics
- [ ] Build cache ontop map's (memcache, redis in future)

### The Main one
- [ ] Make a cool library

Feel free to contribute ;)  
You can contact me at discord: TERISBACK#9125
