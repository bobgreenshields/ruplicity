require_relative '../cmd_item'

module Ruplicity
	class CmdItem
		class OptionalValue < CmdItem

			def key_found(value)
				value
			end


		end
	end
end
