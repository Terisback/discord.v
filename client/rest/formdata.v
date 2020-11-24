module rest

import os
import crypto.rand
import math
import strings

const (
	mime_types = {
		'.css': 'text/css; charset=utf-8'
		'.gif': 'image/gif'
		'.htm': 'text/html; charset=utf-8'
		'.html': 'text/html; charset=utf-8'
		'.jpg': 'image/jpeg'
		'.js': 'application/javascript'
		'.json': 'application/json'
		'.md': 'text/markdown; charset=utf-8'
		'.pdf': 'application/pdf'
		'.png': 'image/png'
		'.svg': 'image/svg+xml'
		'.txt': 'text/plain; charset=utf-8'
		'.wasm': 'application/wasm'
		'.xml': 'text/xml; charset=utf-8'
	}
)

type FormField = string | FormFile

struct FormFile {
pub mut:
	filename string
	content_type string = mime_types['.txt']
	data []byte
}

struct FormData {
pub mut:
	boundary string
	fields map[string]FormField
}

pub fn new() ?FormData {
	b := rand.int_u64(math.max_u64)?
	return FormData{
		boundary: b.hex_full()
		fields: map[string]FormField{}
	}
}

pub fn (mut f FormData) add(name string, text string) {
	f.fields[name] = text
}

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

pub fn (f FormData) header() string {
	return 'multipart/form-data; charset=utf-8; boundary=$f.boundary'
}

pub fn (f FormData) encode() string {
	mut builder := strings.new_builder(200)
	for k, v in f.fields {
		builder.write_b(`\n`)
		match v {
			string {
				builder.write('Content-Disposition: form-data; name=\"$k\"')
				builder.write_b(`\n`)
				builder.write(v)
			}
			FormFile {
				builder.write('Content-Disposition: form-data; name=\"$k\"; filename=\"$v.filename\"')
				builder.write('Content-Type: $v.content_type')
				builder.write_b(`\n`)
				builder.write(v.data.bytestr())
			}
		}
	}
	builder.write('--')
	return builder.str()
}