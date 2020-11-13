![discord.v](https://user-images.githubusercontent.com/26527529/98575853-c348d300-22ca-11eb-86f6-d22cc9b1e0cf.png)

#  

<p align="center">
Yet another feature-rich Discord Bot Framework written in V.<br><i>(Big <b>WIP</b>)</i>
</p>

## How it will look like

```v
import discordv as vd
import discordv.client as nt

fn main(){
    mut client := nt.new(vd.Config{token: 'token'})?
    client.on(.message_create, on_message_create)
    client.run()?
}

fn on_message_create(mut c &nt.Client, e &vd.MessageCreate){
    if e.content == '!ping' {
        c.send(e.channel, 'pong!')?
    }
}
```

## TODO()

- [x] Do basic connection through websocket
- [x] Handle heartbeat (partly)
- [x] Think about more usable event system
- [ ] Do message related REST things
- [ ] Observe rate limits
- [ ] Build cache ontop map's (memcache, redis in future)
- [ ] Gain feedback
- [ ] Make a cool library
