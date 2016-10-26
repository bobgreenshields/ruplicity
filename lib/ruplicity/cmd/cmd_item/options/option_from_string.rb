require 'ruplicity/cmd/cmd_item/options/option'
require 'ruplicity/utility'
require 'ruplicity/errors'

module Ruplicity
	class Option
		class NameSplitter
			NAME_REGEXP = /^--(?<name>\S+)/

			def call(opt_str)
				data = NAME_REGEXP.match(opt_str)
				raise IncorrectlyFormattedOptionError, "an option had no text after the dash or dashes" unless data
				@value = data.post_match.strip
				res = [data[:name], @value]
			end
		end

		class LetterSplitter
			LETTER_REGEXP = /^-(?<name>\S)/
			ALLOWED_SWITCHES = %w(t v)

			def initialize(allowed_switches = ALLOWED_SWITCHES)
				@allowed_switches = allowed_switches.map &:to_s
			end

			def call(opt_str)
				data = LETTER_REGEXP.match(opt_str)
				raise IncorrectlyFormattedOptionError, "an option had no text after the dash or dashes" unless data
				name = data[:name]
				value = data.post_match.strip
				raise IncorrectlyFormattedOptionError,
					"#{opt_str}: a single letter switch must have a value appended to it" if value.length == 0
				raise IncorrectlyFormattedOptionError,
					"#{opt_str}: after a single dash the first letter switch must be one of " \
					"#{@allowed_switches.join(" ")} the option had #{name}" unless @allowed_switches.include?(name.downcase)
				res = [name, value]
			end
		end

		class OptionFromString < Option
			NAME_MAP = {t: :restore_time, time: :restore_time, v: :verbosity}

			attr_reader :value

			def initialize(option_string)
				@option_string = option_string
				verify_no_of_dashes
				@name_string, @value = splitter.call(@option_string)
				@name = string_to_name(@name_string)
			end

			def verify_no_of_dashes
				unless [1,2].include? no_of_dashes
					raise IncorrectlyFormattedOptionError,
						"#{@option_string}: an option must begin with 1 or 2 dashes, this one had #{no_of_dashes}"
				end
			end

			def string_to_name(name_string)
				result = Utility.to_key name_string
				NAME_MAP.fetch(result) { |key| key }
			end

			def splitter
				class_hash = { 1 => Option::LetterSplitter, 2 => Option::NameSplitter }
				splitter_class = class_hash.fetch(no_of_dashes) { raise IncorrectlyFormattedOptionError,
					"OptionFromString#splitter should never get called with a number of dashes other than 1 or 2, " \
					"this time it was called with #{no_of_dashes} for #{@option_string}" }
				splitter_class.new
			end

			def no_of_dashes
				@no_of_dashes ||= calculate_no_of_dashes
			end

			def calculate_no_of_dashes
				data = /^(?<dashes>-*)/.match @option_string
				data[:dashes].length
			end
		end
	end
end
