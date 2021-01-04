
## discord.[v](https://github.com/Terisback/discord.v) 0.1.0 - *kinda major*
*04 Jan 2021*
- Separate `client` module
    - Gateway can be imported and used anywhere as module.
    - Client implemented in root module (discord.v)
- Delete `sharding` module
- Implement Sharding in Client
- Delete `structs` module
- All structs implemented in root module (discord.v)
- Implement all events from Gateway
- Concat all struct files into [one](https://github.com/Terisback/discord.v/blob/master/structs.v)
- Implement some REST
    - Rate Limiting with buckets
    - `multipart/form-data` for file uploading
    - `channel_message_send` request can send text, embeds, images
- Create 3 examples
    - Simplest [Ping-Pong Bot](https://github.com/Terisback/discord.v/blob/master/examples/ping-pong/main.v)
    - Embed [example](https://github.com/Terisback/discord.v/blob/master/examples/send-embed/main.v)
    - Upload image [example](https://github.com/Terisback/discord.v/blob/master/examples/upload-image/main.v)
- New [FancyLog](https://github.com/Terisback/discord.v/blob/master/fancylog/log.v) for internal logging
- Get rid of `util` module, now snowflake accessible by `discordv.snowflake`


## discord.[v](https://github.com/Terisback/discord.v) 0.0.1 - *doo doo*
*13 Nov 2020*
- Established a connection to the Discord gateway
- Rewrited EventBus from vlib to fit our needs (custom EventHandlerFn)
- We have Ready, MessageCreate, MessageUpdate, MessageDelete events to subscribe
- Sharding barebones