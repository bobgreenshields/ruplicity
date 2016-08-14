#require_relative '../cmd_item/switch.rb'
require "ruplicity/cmd/cmd_item/switch"

module Ruplicity
	class CmdItem
		class NamedValue < Switch

			def key_found(value)
				"#{switch_str} #{value}"
			end

		end
	end
end
