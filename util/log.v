module util

import term

// Remove then release

const (
	colors_supported = term.can_show_color_on_stdout()	
)

pub fn log(txt string) {
	match colors_supported {
		true { 
			v := term.rgb(95, 155, 230, 'v')
			println(term.bright_white('[discord.$v] ') + term.gray(txt)) 
		}
		else { println('[discord.v] ' + txt) }
	}
}