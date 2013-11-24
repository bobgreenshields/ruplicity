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
	end
end
