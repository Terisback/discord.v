module fancylog

import os
import log
import term

pub const (
	colors_supported_stdout = term.can_show_color_on_stdout()	
	colors_supported_stderr = term.can_show_color_on_stderr()
)

// PrefixFn represents function returns prefix for every log output
pub type PrefixFn = fn(level log.Level, colors_supported bool) string

// Log represents a logging object
pub struct Log {
mut:
	fancy bool = true
	has_prefix_func bool
	prefix_str string
	prefix_func PrefixFn
	output_to_file bool
	output_file os.File
	output_filename string
pub mut:
	level log.Level = .info
}

// Create new Log
pub fn new() &Log {
	mut log := &Log{}
	return log
}

// Set prefix text, log message will look like this '${prefix}${log_message}'.
// There is no space between the prefix and the message, if it is important for you, leave a space in the prefix itself.
pub fn (mut l Log) set_prefix_text(prefix string) {
	l.prefix_str = prefix
	l.has_prefix_func = false
}

// Set prefix func, every log output it will call 'prefix_func' with 'level' and 'colors_supported' arguments.
// By default log doesn't output log level, you can enable it by 'set_output_level(bool)', but can implement it in your 'prefix_func'.
pub fn (mut l Log) set_prefix_func(prefix_func PrefixFn) {
	l.prefix_func = prefix_func
	l.has_prefix_func = true
}

// Set log level, you can specify the max log level.
// If you set log level to '.warn' then '.debug' and '.info' level messages will not be displayed.
pub fn (mut l Log) set_level(level log.Level) {
	l.level = level
}

// Sets output file with 'output_filename', if 'output_filename' is empty then it flush and close output file and sets 'output_to_file' to false.
pub fn (mut l Log) set_output_file(output_filename string) {
	if l.output_file.is_opened {
		l.flush()
		l.close()
	}
	if l.output_filename == '' {
		l.output_to_file = false
		return
	}
	l.output_filename = os.real_path(output_filename)
	output_file := os.open_append(l.output_filename) or {
		panic('error while opening log file $l.output_filename for appending')
	}
	l.output_file = output_file
	l.output_to_file = true
}

// Disables fancy :(
pub fn (mut l Log) disable_fancy() {
	l.fancy = false
}

// Writes the log file content to disk.
pub fn (mut l Log) flush() {
	l.output_file.flush()
}

// Closes the log file.
pub fn (mut l Log) close() {
	l.output_file.close()
}

// Returns colorful (depends on colors_supported consts) prefix
fn (mut l Log) prefix(level log.Level) string {
	if l.has_prefix_func {
		if l.output_to_file || !l.fancy {
			return l.prefix_func(level, false)
		}
		match level {
			.fatal { return l.prefix_func(level, colors_supported_stderr) }
			else { return l.prefix_func(level, colors_supported_stdout)	}
		}
	} else {
		return l.prefix_str
	}
}

// Logs to file or stdout (depends on 'output_to_file')
fn (mut l Log) log(level log.Level, text string) {
	output := l.prefix(level) + text
	if l.output_to_file {
		l.output_file.writeln(output)
	} else {
		match level {
			.fatal, .error {eprintln(output)}
			else {println(output)}
		}
	}
}

fn (mut l Log) colors_supported() bool {
	return !l.output_to_file && colors_supported_stdout
}

// Logs to stderr with 'message' then panics
pub fn (mut l Log) fatal(message string) {
	if l.level < .fatal { return }
	if !l.output_to_file && colors_supported_stdout {
		l.log(.fatal, term.bright_bg_red(term.black(message)))
	} else {
		l.log(.fatal, message)
	}
	l.close()
	panic(l.prefix(.fatal) + message)
}

// Logs to stderr with 'message' and '.error' level.
// By default adds bright red color to message, you can disable it by 'disable_fancy()'
pub fn (mut l Log) error(message string) {
	if l.level < .error { return }
	if l.colors_supported() && l.fancy {
		l.log(.error, term.bright_red(message))
	} else {
		l.log(.error, message)
	}
}

// Logs to stdout with '.warn' level.
// By default adds bright yellow color to message, you can disable it by 'disable_fancy()'
pub fn (mut l Log) warn(message string) {
	if l.level < .warn { return }
	if l.colors_supported() && l.fancy {
		l.log(.warn, term.bright_yellow(message))
	} else {
		l.log(.warn, message)
	}
}

// Logs to stdout with '.warn' level.
// By default adds bright green color to message, you can disable it by 'disable_fancy()'
pub fn (mut l Log) info(message string) {
	if l.level < .info { return }
	if l.colors_supported() && l.fancy {
		l.log(.info, term.bright_green(message))
	} else {
		l.log(.info, message)
	}
}

// Logs to stdout with '.debug' level. It doesn't add color, or smth, just debug message... :(
pub fn (mut l Log) debug(message string) {
	if l.level < .debug { return }
	l.log(.debug, message)
}