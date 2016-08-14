require_relative '../cmd_item'

module Ruplicity

	class CmdItem
		class Switch < CmdItem

			def switch_str
				"--#{@name}"
			end

			def key_found(value)
				switch_str
			end
		end
	end

end
