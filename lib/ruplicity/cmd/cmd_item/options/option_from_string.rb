require 'ruplicity/utility'
require 'ruplicity/errors'

module Ruplicity
	class NameSplitter
		NAME_REGEXP = /^(?<name>\S+)/

		def call(opt_str)
			data = NAME_REGEXP.match(opt_str)
			raise IncorrectlyFormattedOptionError, "an option had no text after the dash or dashes" unless data
			@value = data.post_match.strip
			res = [Utility.to_key(data[:name]), @value]
		end
	end

	class LetterSplitter
		LETTER_REGEXP = /^(?<name>\S)/
		ALLOWED_SWITCHES = %i(t v)

		def call(opt_str)
			data = LETTER_REGEXP.match(opt_str)
			raise IncorrectlyFormattedOptionError, "an option had no text after the dash or dashes" unless data
			@value = data.post_match.strip
			raise IncorrectlyFormattedOptionError,
				"a single letter switch must have a value appended to it" if @value.length == 0
			res = [Utility.to_key(data[:name]), @value]
		end
	end
end
