module Ruplicity
	module SetErrors

		def has_no_errors?
			errors.empty?
		end

		def has_errors?
			 ! has_no_errors?
		end

		def post_error(error)
			errors << error
		end

		def errors
			@errors ||= []
		end

		def fwd_errors_to(error_store)
			@errors = error_store
		end
	end
end
