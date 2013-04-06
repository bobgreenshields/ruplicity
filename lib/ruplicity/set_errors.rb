module Ruplicity
	module SetErrors
		attr_writer :error_poster

		def has_no_errors?
			errors.empty?
		end

		def has_errors?
			 ! has_no_errors?
		end

		def post_error(error)
			if @error_poster
				@error_poster.call(error)
			else
				errors << error
			end
		end

		def errors
			@errors ||= []
		end
	end
end
