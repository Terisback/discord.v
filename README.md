![discord.v](https://user-images.githubusercontent.com/26527529/98575853-c348d300-22ca-11eb-86f6-d22cc9b1e0cf.png)

#  

<p align="center">
Yet another feature-rich Discord Bot Framework written in V <i>(<b>WIP</b>)</i><br>
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
        client.channel_message_send(evt.channel_id, content: 'pong!') or { }
    }
}
```
More [examples](https://github.com/Terisback/discord.v/blob/master/examples/)

## How to install

*discord.v* uses openssl, be sure it is installed `apt install libssl-dev`  
> Only way to run it on Windows is to use WSL (or install `openssl` headers somehow)  

```bash
git clone https://github.com/Terisback/discord.v.git ~/.vmodules/discordv
```

And then import `discordv` wherever you like

## Contact

Feel free to contribute ;)  
You can contact me at discord: TERISBACK#9125
