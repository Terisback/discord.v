module formdata

import os
import strings
import encoding.base64

// Copied mime types from net.http module
const (
	mime_types = {
		'.css':  'text/css; charset=utf-8'
		'.gif':  'image/gif'
		'.htm':  'text/html; charset=utf-8'
		'.html': 'text/html; charset=utf-8'
		'.jpg':  'image/jpeg'
		'.js':   'application/javascript'
		'.json': 'application/json'
		'.md':   'text/markdown; charset=utf-8'
		'.pdf':  'application/pdf'
		'.png':  'image/png'
		'.svg':  'image/svg+xml'
		'.txt':  'text/plain; charset=utf-8'
		'.wasm': 'application/wasm'
		'.xml':  'text/xml; charset=utf-8'
	}
)

// FormField can be text or file
type FormField = FormFile | string

// Contains the name and content of the file
struct FormFile {
pub mut:
	filename     string
	content_type string = 'application/octet-stream'
	data         []byte
}

// FormData represents multipart/form-data 
struct FormData {
pub mut:
	boundary string
	fields   map[string]FormField
}

// Create new FormData with default boundary
pub fn new() ?FormData {
	return FormData{
		boundary: 'X-DISCORD.V-BOUNDARY'
		fields: map[string]FormField{}
	}
}

// Add text field
pub fn (mut f FormData) add(name string, text string) {
	f.fields[name] = text
}

// Add file field
pub fn (mut f FormData) add_file(name string, filename string, data []byte) {
	ext := os.file_ext(filename)
	if ext in mime_types {
		f.fields[name] = FormFile{
			filename: filename
			content_type: mime_types[ext]
			data: data
		}
	} else {
		f.fields[name] = FormFile{
			filename: filename
			data: data
		}
	}
}

// Returns http header to include it into request
pub fn (f FormData) content_type() string {
	return 'multipart/form-data; charset=utf-8; boundary=${f.boundary}'
}

// Encode FormData, returns body of http request
pub fn (f FormData) encode() string {
	mut builder := strings.new_builder(200)
	builder.write_b(`\n`)
	for k, v in f.fields {
		builder.write('--${f.boundary}\n')
		match v {
			string {
				builder.write('Content-Disposition: form-data; name=\"${k}\"\n')
				builder.write_b(`\n`)
				builder.write(v)
				builder.write_b(`\n`)
			}
			FormFile {
				builder.write('Content-Disposition: form-data; name=\"${k}\"; filename=\"${v.filename}\"\n')
				builder.write('Content-Type: ${v.content_type}\n')
				builder.write('Content-Transfer-Encoding: base64\n')
				builder.write_b(`\n`)
				builder.write(base64.encode(v.data.bytestr()))
				builder.write_b(`\n`)
			}
		}
	}
	builder.write('--${f.boundary}--')
	return builder.str()
}
