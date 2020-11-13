![discord.v](https://user-images.githubusercontent.com/26527529/98575853-c348d300-22ca-11eb-86f6-d22cc9b1e0cf.png)

#  

<p align="center">
<b>discord.v</b> - Yet another easy to use, feature-rich, and async ready API wrapper for Discord written in V. <br><i>(Big <b>WIP</b>)</i>
</p>

## How it will look like

```v
import discordv as vd
import discordv.client as cl

fn main(){
    mut client := cl.new(vd.Config{token: 'token'})?

    client.on(.ready, on_ready)
    client.on(.message_create, on_message_create)

    client.run()?
}

fn on_ready(mut c &cl.Client, e &vd.Ready){
    log('Bot is ready!')
    log('Guilds count: $e.guilds.len')
    log('All guilds:')
    for i, guild in e.guilds {
        log('${i+1}\. $guild.id')
    }
}

fn on_message_create(mut c &cl.Client, e &vd.MessageCreate){
    log('message: [id:$e.id, content:$e.content]')
}
```

## TODO()

- [x] Do basic connection through websocket
- [x] Handle heartbeat (partly)
- [x] Think about more usable event system
- [ ] Do message related REST things
- [ ] Observe rate limits
- [ ] Gain feedback
- [ ] Make a cool library
