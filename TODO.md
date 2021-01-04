
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