require_relative './parse_action'

module Ruplicity
	class ParseActionWithDir < ParseAction
		def action_list
			%w(full incr verify restore)
		end

		def additional_checks(args)
			unless args.has_key?(:dir)
				post_error("Action #{args[:action]} must have a dir key given")
			end
		end

		def res_array(args)
			if %w(full incr).include?(args[:action])
				[ args[:action] ] + args[:options] + [ args[:dir], args[:url] ]
			else
				[ args[:action] ] + args[:options] + [ args[:url], args[:dir] ]
			end
		end

	end
end
