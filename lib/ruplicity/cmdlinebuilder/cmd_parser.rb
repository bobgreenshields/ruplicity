require_relative '../set_errors'

module Ruplicity

	class CmdParser
		include SetErrors

		def initialize(args)
			@args = args
		end

    def cmd_arr(arr)
    	if uses_this_parser?
    		check_for_errors
    		has_no_errors? ? amend_cmd_array(arr) : arr
    	else
    		arr
			end
    end

		private

		def uses_this_parser?
			raise "#uses_this_parser? SubclassResponsibility"
		end

		def check_for_errors
			raise "#check_for_errors SubclassResponsibility"
		end

		def amend_cmd_array(arr)
			raise "#amend_cmd_array SubclassResponsibility"
		end
	end

end
