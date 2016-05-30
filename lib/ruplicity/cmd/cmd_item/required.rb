require_relative '../cmd_item/switch.rb'

module Ruplicity
	class CmdItem
		class Required < Switch

			def key_found(value)
				"#{switch_str} #{value}"
			end

			def key_not_found
				add_error "#{self.class} expected to find a params hash " \
									"key of :#{symbol_to_find} but was not found"
				nil
			end
		end
	end
end
