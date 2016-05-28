module Ruplicity
	class CmdItem
		attr_accessor :name

		def initialize
			@name = ""
		end

		def symbol_to_find
			@name.gsub("-", "_").to_sym
		end
	end

end
