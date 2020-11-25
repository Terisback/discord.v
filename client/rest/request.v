module rest

import net.http

const (
	api = 'https://discord.com/api/v8'
	bot_user_agent = 'DiscordBot (https://github.com/Terisback/discord.v, v0.0.1)'
)

pub fn new_request(token string, method http.Method, path string) ?http.Request {
	mut req := http.new_request(method, api + path, '')?
	req.add_header('Authorization', 'Bot $token') 
	req.add_header('User-Agent', bot_user_agent)
	return req
}