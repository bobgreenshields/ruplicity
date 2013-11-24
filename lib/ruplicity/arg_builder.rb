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

		def opt_from_key(key)
			"--" + key.to_s.gsub('_', '-')
		end

		def argless_options_from_keys(args, opts)
			key_options = %w(--dry-run  --force  --s3-use-new-style  --s3-european-buckets)
			key_options.select do | opt |
				!opts.include?(opt) and args.has_key?(key_from_opt(opt))
			end + opts
		end

		def options_with_args_from_keys(args, opts)
			keys = [:name, :encrypt_key, :full_if_older_than, :sign_key, :verbosity]
			keys.inject([]) do | new_opts, key |
				unless args.has_key?(key)
					new_opts
				else
					opts.delete_if { | opt | /#{opt_from_key(key)}/.match(opt) }
					new_opts << "#{opt_from_key(key)} #{args[key]}"
				end
			end + opts
		end
	end
end
