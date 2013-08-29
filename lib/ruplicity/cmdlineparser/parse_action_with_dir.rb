require_relative './parse_action'

module Ruplicity
	class ParseActionWithDir < ParseAction
		def action_list
			%w(full incr verify restore)
		end

	end
end
