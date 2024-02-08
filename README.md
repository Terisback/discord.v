# discord.v

> [!CAUTION]
> I dropped the support of this lib at the end of 2021. The reason is that I don't care anymore about V, fixing "bugs" around new syntax and catching segfaults from socket interactions is not fun. Feel free to fork and keep alive if you need it.  
>
> __There is another beginning at [DarpHome/discord.v](https://github.com/DarpHome/discord.v), please check them.__

## Example

```v
import terisback.discordv as vd

fn main() {
    mut client := vd.new(token: 'token') ?
    client.on_message_create(on_ping)
    client.run().wait()
}

fn on_ping(mut client vd.Client, evt &vd.MessageCreate) {
    if evt.content == '!ping' {
        client.channel_message_send(evt.channel_id, content: 'pong!') or { }
    }
}
```
More [examples](https://github.com/Terisback/discord.v/blob/master/examples/)

## How to install

*discord.v* uses openssl, be sure it is installed `apt install libssl-dev`  
> Only way to run it on Windows is to use WSL (or install `openssl` headers somehow) 

### Install via vpm

```bash
v install Terisback.discordv
```

### Install via git

```bash
git clone https://github.com/Terisback/discord.v.git ~/.vmodules/terisback/discordv
```

And then import `terisback.discordv` wherever you like

## TODO()

### First milestone
- [x] Connect to gateway
- [x] Handle heartbeat
- [x] Event system (pub/sub)
- [x] REST for sending messages
- [x] Implement `multipart/form-data` for file sending
- [x] Do usual `application/json` for sending without binary data
- [x] Handle Gateway events
  - [x] Audit Log
  - [x] Channel
  - [x] Emoji
  - [x] Guild
  - [x] Invite
  - [x] User
  - [x] Voice
  - [x] Webhook
  - [x] Slash Command
- [ ] Create examples (3/4)
- [ ] Documentation

### Second milestone
- [ ] Handle REST
  - [x] Audit Log
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
- [x] Fancy log
- [ ] Command router
- [ ] Think about tests

### Third milestone (till V v0.3)
- [ ] Translate dispatch to generics (not sure about that)
- [ ] Build cache ontop map's (memcache, redis in future)

### The Main one
- [ ] Make a cool library

## Contact

Feel free to contribute ;)  
You can contact me at discord: TERISBACK#9125
