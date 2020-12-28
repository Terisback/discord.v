module discordv

import time
import x.json2 as json
import discordv.util.snowflake

pub struct Embed {
pub mut:
	title string
	description string
	url string
	timestamp time.Time
	color int
	footer EmbedFooter
	image EmbedImage
	thumbnail EmbedThumbnail
	video EmbedVideo
	provider EmbedProvider
	author EmbedAuthor
	fields []EmbedField
}

pub fn (mut embed Embed) from_json(f json.Any){
	mut obja := f.as_map()
	for k, v in obja {
		match k {
			'title' {embed.title = v.str()}
			'description' {embed.description = v.str()}
			'url' {embed.url = v.str()}
			'timestamp' {
				embed.timestamp = time.parse_iso8601(v.str()) or {
					time.unix(int(snowflake.discord_epoch / 1000))
				}
			}
			'color' {embed.color = v.int()}
			'footer' {
				mut obj := EmbedFooter{}
				obj.from_json(v)
				embed.footer = obj
			}
			'image' {
				mut obj := EmbedImage{}
				obj.from_json(v)
				embed.image = obj
			}
			'thumbnail' {
				mut obj := EmbedThumbnail{}
				obj.from_json(v)
				embed.thumbnail = obj
			}
			'video' {
				mut obj := EmbedVideo{}
				obj.from_json(v)
				embed.video = obj
			}
			'provider' {
				mut obj := EmbedProvider{}
				obj.from_json(v)
				embed.provider = obj
			}
			'author' {
				mut obj := EmbedAuthor{}
				obj.from_json(v)
				embed.author = obj
			}
			'fields' {
				mut obj := EmbedImage{}
				obj.from_json(v)
				embed.image = obj
			}
			else {}
		}
	}
}

pub fn (mut embeds []Embed) from_json(f json.Any){
	mut obj := f.arr()
	for embed in obj{
		mut e := Embed{}
		e.from_json(embed)
		embeds << e
	}
}

pub fn (embed Embed) to_json() json.Any{
	mut obj := map[string]json.Any{}
	obj['title'] = embed.title
	obj['description'] = embed.description
	obj['url'] = embed.url
	obj['color'] = embed.color
	obj['footer'] = embed.footer.to_json()
	obj['image'] = embed.image.to_json()
	obj['thumbnail'] = embed.thumbnail.to_json()
	obj['video'] = embed.video.to_json()
	obj['provider'] = embed.provider.to_json()
	obj['author'] = embed.author.to_json()
	obj['fields'] = embed.fields.to_json()
	return obj
}

pub fn (embed []Embed) to_json() json.Any{
	mut obj := []json.Any{}
	for e in embed{
		obj << e.to_json()
	}
	return obj
}

pub struct EmbedFooter {
pub mut:
	text string
	icon_url string
	proxy_icon_url string
}

pub fn (mut ef EmbedFooter) from_json(f json.Any){
	mut obj:=f.as_map()
	for k, v in obj{
		match k {
			'text' {ef.text = v.str()}
			'icon_url' {ef.icon_url = v.str()}
			'proxy_icon_url' {ef.proxy_icon_url = v.str()}
			else {}
		}
	}
}

pub fn (ef EmbedFooter) to_json() json.Any {
	mut obj := map[string]json.Any
	obj['text'] = ef.text
	obj['icon_url'] = ef.icon_url
	obj['proxy_icon_url'] = ef.proxy_icon_url
	return obj
}

pub fn (ef EmbedFooter) str() string{
	return ef.to_json().str()
}

pub struct EmbedImage {
pub mut:
	url string
	proxy_url string
	height int
	width int
}

pub fn (mut ei EmbedImage) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'url' {ei.url = v.str()}
			'proxy_url' {ei.proxy_url = v.str()}
			'height' {ei.height = v.int()}
			'width' {ei.width = v.int()}
			else {}
		}
	} 
}

pub fn (ei EmbedImage) to_json() json.Any {
	mut obj := map[string]json.Any
	obj['url'] = ei.url
	obj['proxy_url'] = ei.proxy_url
	obj['height'] = ei.height
	obj['width'] = ei.width
	return obj
}

pub fn (ei EmbedImage) str() string {
	return ei.to_json().str()
}

pub struct EmbedThumbnail {
pub mut:
	url string
	proxy_url string
	height int
	width int
}

pub fn (mut et EmbedThumbnail) from_json(f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'url' {et.url = v.str()}
			'proxy_url' {et.proxy_url = v.str()}
			'height' {et.height = v.int()}
			'width' {et.width = v.int()}
			else {}
		}
	} 
}

pub fn (et EmbedThumbnail) to_json() json.Any {
	mut obj := map[string]json.Any
	obj['url'] = et.url
	obj['proxy_url'] = et.proxy_url
	obj['height'] = et.height
	obj['width'] = et.width
	return obj
}

pub fn (et EmbedThumbnail) str() string {
	return et.to_json().str()
}

pub struct EmbedVideo {
pub mut:
	url string
	height int
	width int
}

pub fn (mut ev EmbedVideo) from_json(f json.Any) {
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'url' {ev.url = v.str()}
			'height' {ev.height = v.int()}
			'width' {ev.width = v.int()}
			else {}
		}
	} 
}

pub fn (ev EmbedVideo) to_json() json.Any {
	mut obj := map[string]json.Any
	obj['url'] = ev.url
	obj['height'] = ev.height
	obj['width'] = ev.width
	return obj
}

pub fn (ev EmbedVideo) str() string {
	return ev.to_json().str()
}

pub struct EmbedProvider {
pub mut:
	name string
	url string
}

pub fn (mut ep EmbedProvider) from_json (f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'name' {ep.name = v.str()}
			'url' {ep.url = v.str()}
			else {}
		}
	}
}

pub fn (ep EmbedProvider) to_json() json.Any {
	mut obj := map[string]json.Any
	obj['name'] = ep.name
	obj['url'] = ep.url
	return obj
}

pub fn (ep EmbedProvider) str() string {
	return ep.to_json().str()
}

pub struct EmbedAuthor {
pub mut:
	name string
	url string
	icon_url string
	proxy_icon_url string
}

pub fn (mut ea EmbedAuthor) from_json (f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'name' {ea.name = v.str()}
			'url' {ea.url = v.str()}
			'icon_url' {ea.icon_url = v.str()}
			'proxy_icon_url' {ea.proxy_icon_url = v.str()}
			else {}
		}
	}
}

pub fn (ea EmbedAuthor) to_json() json.Any{
	mut obj := map[string]json.Any
	obj['name'] = ea.name
	obj['url'] = ea.url
	obj['icon_url'] = ea.icon_url
	obj['proxy_icon_url'] = ea.proxy_icon_url
	return obj
}

pub fn (ea EmbedAuthor) str() string {
	return ea.to_json().str()
}

pub struct EmbedField {
pub mut:
	name string
	value string
	inline bool
}

pub fn (mut ef EmbedField) from_json (f json.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'name' {ef.name = v.str()}
			'value' {ef.value = v.str()}
			'inline' {ef.inline = v.bool()}
			else {}
		}
	}
}

pub fn (ef EmbedField) to_json() json.Any {
	mut obj := map[string]json.Any{}
	obj['name'] = ef.name
	obj['value'] = ef.value
	obj['inline'] = ef.inline
	return obj
}

pub fn (ef []EmbedField) to_json() json.Any {
	mut obj := []json.Any{}
	for field in ef{
		obj << field.to_json()
	}
	return obj
}

pub fn (ef EmbedField) str() string {
	return ef.to_json().str()
}