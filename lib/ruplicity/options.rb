module Ruplicity
	class Options
		def initialize(option_array)
			
		end

		def key_from_option(option)
			match = /--(\S+)(\s+\S+)*$/.match option
			if match
				match[1].downcase.gsub("-", "_").to_sym
			else
				raise ArgumentError, "option #{option} does not have a good format"
			end
			
		end
		
	end
	
end
