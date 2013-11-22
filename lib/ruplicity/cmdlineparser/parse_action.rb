require_relative '../set_errors'

module Ruplicity

	class ParseAction
		include SetErrors

		def action_list
			raise "SubclassResponsibility"
		end

		def additional_checks(args)
			raise "SubclassResponsibility"
		end

		def res_array(args)
			raise "SubclassResponsibility"
		end

		def parses_this_action?(args)
			if args.has_key?(:action)
				action_list.include?(args[:action])
			else
				post_error("No action key, cannot identify action to parse")
				false
			end
		end

		def check_for_url(args)
			if args.has_key?(:url)
				true
			else
				post_error("No url key, all actions require a url")
				false
			end
		end

		def parse(args)
			check_for_url(args)
			additional_checks(args)
			res_array(args)
		end
	end

end