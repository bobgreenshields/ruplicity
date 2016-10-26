module Ruplicity

	module Utility
		module_function

		def to_key(key_name)
			key_name.to_s.downcase.strip.tr("-","_").to_sym
		end

		def to_option_string(key)
			"--#{key.to_s.downcase.tr("_","-")}"
		end
	end
	
end
