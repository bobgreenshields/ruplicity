module Ruplicity
	class ArgBuilder
		def normalise_keys(args)
			@res = {}
			args.each_pair { | key, val | @res[normalise_key(key)] = val }
			@res
		end

		def normalise_key(key)
			key.to_s.downcase.gsub('-', '_').to_sym
		end

		def key_from_opt(opt)
			opt[2, opt.length-2].gsub('-', '_').to_sym
		end

		def argless_options_from_keys(args, opts)
			key_options = %w(--dry-run  --force  --s3-use-new-style  --s3-european-buckets)
			key_options.select do | opt |
				!opts.include?(opt) and args.has_key?(key_from_opt(opt))
			end
		end
	end
end
