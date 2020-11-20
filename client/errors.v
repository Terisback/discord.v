module client

import x.json2 as json

enum RestResponseCode {
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

enum ApiErrorCode {
	general_error
	unknown_account = 10001
	unknown_application = 10002
	unknows_channel = 10003
	missing_access = 50001
	// TODO
}

struct ApiErrorMessage {
	code ApiErrorCode
	errors json.Any
	message string
}