require_relative '../set_errors'

module Ruplicity

	class SubClassRespError < StandardError
	end

	class CmdBuilder
		include SetErrors

		def self.use_this?(args)
			raise SubClassRespError, "#use_this? SubclassResponsibility"
		end

		def initialize(args)
			@args = args
		end

    def cmd_arr(arr)
#    	if uses_this_parser?
    	if self.class.use_this?(@args)
    		check_for_errors
    		has_no_errors? ? amend_cmd_array(arr) : arr
    	else
    		arr
			end
    end

		def uses_this_parser?
			raise SubClassRespError, "#uses_this_parser? SubclassResponsibility"
		end

		private

		def check_for_errors
			raise SubClassRespError, "#check_for_errors SubclassResponsibility"
		end

		def amend_cmd_array(arr)
			raise SubClassRespError, "#amend_cmd_array SubclassResponsibility"
		end
	end

end
