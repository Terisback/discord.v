<p align="center">
<img src="https://user-images.githubusercontent.com/26527529/98575853-c348d300-22ca-11eb-86f6-d22cc9b1e0cf.png"/>
</p>

<h1></h1>

<p align="center">
<b>discord.v</b> - Yet another easy to use, feature-rich, and async ready API wrapper for Discord written in V. <br><i>(Big <b>WIP</b>)</i>
</p>

## How it will look like

```v
fn main(){
	mut client := vd.new('token')?
	defer { client.stay_connected()? }

	client.on(.ready, on_ready)
}

fn on_ready(mut c vd.Client, r &vd.Ready){
	println('Bot is ready!')
	println('Your username is $r.user.username')
}
```

## TODO()

- [x] Do basic connection through websocket
- [x] Handle heartbeat (partly)
- [ ] Think about more usable event system
- [ ] Do message related REST things
- [ ] Observe rate limits
- [ ] Gain feedback
- [ ] Make a cool library