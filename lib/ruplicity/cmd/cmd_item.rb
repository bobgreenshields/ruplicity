module Ruplicity
	class CmdItem
		attr_accessor :name, :errors

		def initialize(errors: [])
			@name = ""
			@errors = errors
		end

		def symbol_to_find
			@name.gsub("-", "_").to_sym
		end

		def key_found(value)
		end

		def key_not_found
			nil
		end

	
		def call(params)
			if params.key? symbol_to_find
				key_found(params[symbol_to_find])
			else
				key_not_found
			end
		end
	end

end
