module rest

import net.http

pub struct REST {
pub:
	token string
mut:
	rl &RateLimit
}

pub fn new(token string) &REST{
	return &REST{
		token: token
		rl: &RateLimit{}
	}
}

pub fn (mut rest REST) do(req http.Request) ?http.Response {
	// TODO: RateLimit thingy there
	resp := req.do()?
	return resp
}