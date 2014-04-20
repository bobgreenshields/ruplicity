require_relative '../set_errors'

module Ruplicity

	class NormalizeArgs
		include SetErrors

		def initialize(args)
			@args = args
		end

		def args
			old_keys = @args.keys
			old_keys.inject({}) do |new_args, old_key|
				new_key = safe_normalize_key(new_args, old_key)
				new_args[new_key] = normalize_value(@args[old_key])
				new_args
			end
		end

		private

		def safe_normalize_key(new_args, old_key)
			res = normalize_key(old_key)
			if new_args.has_key?(res)
				post_error("#{old_key} when normalized was a duplicate key")
			end
			res
		end

		def normalize_key(old_key)
			res = old_key.to_s
			res = res.downcase
			res = res.gsub('-', '_')
			res.to_sym
		end

		def normalize_value(old_value)
			old_value.chomp.strip
		end

	end
end
