require_relative './optional_value'

module Ruplicity
	class CmdItem
		class RequiredValue < OptionalValue 

			def key_found(value)
				value
			end

			def key_not_found
				add_error "#{self.class} expected to find a params hash " \
									"key of :#{symbol_to_find} but was not found"
				nil
			end

		end
	end
end
