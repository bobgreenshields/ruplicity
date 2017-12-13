require "ruplicity/cmd/cmd_item"
require "ruplicity/cmd/cmd_item/options/option_array"
require 'ruplicity/cmd/cmd_item/options/option_from_string'

module Ruplicity

	class CmdItem
		class Options < CmdItem
			def call(params)
				@option_array = OptionArray.new
				load_string_options(params.fetch(:options) { [] })

				nil
			end

			def load_string_options(array_of_option_strings)
				opts = array_of_option_strings.map { |string| Option::OptionString.new(string) }
				@option_array.initialize_options(opts)
			end
				


		end
	end

end
