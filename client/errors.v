module client

enum RestResponseCode{
	ok = 200
	created = 201
	no_content = 204
	not_modified = 304
	bad_request = 400
	unauthorized = 401
	forbidden = 403
	not_found = 404
	method_not_allowed = 405
	too_many_requests = 429
	gateway_unavailable = 502
}