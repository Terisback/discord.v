![discord.v](https://user-images.githubusercontent.com/26527529/98575853-c348d300-22ca-11eb-86f6-d22cc9b1e0cf.png)

#  

<p align="center">
Yet another feature-rich Discord Bot Framework written in V.<br><i>(Big <b>WIP</b>)</i>
</p>

## Example

```v
import discordv as d
import discordv.client as vd

fn main(){
    mut client := vd.new(d.Config{token: 'token'})?
    client.on(.message_create, on_message_create)
    client.open()?
}

fn on_message_create(mut client &vd.Client, evt &d.MessageCreate){
    if evt.content == '!ping' {
        client.send(evt.channel_id, 'pong!') or {}
    }
}
```

## TODO()

### First milestone
- [x] Connect to gateway
- [x] Handle heartbeat
- [x] Event system (pub/sub)
- [x] REST for sending messages
- [x] Implement `multipart/form-data` for file sending
- [ ] Implement almost all structs
- [ ] Create more examples

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
  - [ ] Observe rate limits
- [ ] Fancy log
- [ ] Command router
- [ ] Think about tests

### Third milestone (till V v0.3)
- [ ] Translate dispatch to generics
- [ ] Build cache ontop map's (memcache, redis in future)

### The main one
- [ ] Make a cool library

Feel free to contribute ;)  
You can contact me at discord: TERISBACK#9125
