require_relative '../set_errors'

module Ruplicity

	class CmdParser
		include SetErrors

		def initialize(args)
			@args = args
			normalize_args
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

		def normalize_key(sym_key)
			str_key = sym_key.to_s
			unless @args.has_key?(sym_key)
				if @args.has_key?(str_key)
					@args[sym_key] = @args[str_key]
				end
			end
		end
		
		def normalize_args
			raise "#normalize_args SubclassResponsibility"
		end
		
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
