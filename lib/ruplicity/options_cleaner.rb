module Ruplicity
	class OptionsCleaner
		def clean(opts)
			opts.map! { |opt| clean_opt(opt) }
		end

		def clean_opt(opt)
			opt.strip!
			downcase_opt(opt)
		end

		def downcase_opt(opt)
			@opt_has_arg_regex ||= /(\S+)\s+(.+)/
			opt_has_arg = @opt_has_arg_regex.match(opt)
			if opt_has_arg
				"#{opt_has_arg[1].downcase} #{opt_has_arg[2]}"
			else
				opt.downcase
			end
		end
	end



end
