require 'base_env'

class BackupEnv

	include BaseEnv

	def check_add_item_args(name, val)
		unless name.kind_of? String
			raise ArgumentError, "The value #{name} is not a valid environment var name"
		end
		if name == ""
			raise ArgumentError, "An environment var name cannot be an empty string"
		end
		unless val.kind_of? String
			raise(ArgumentError, "The environment variable #{name} cannot be set with " +
				"the value #{val}, must be a string")
		end
	end

	def check_fill_arg(fillval)
		unless fillval.kind_of? Hash
			raise ArgumentError, "Fill must be passed a hash to fill from not a #{fillval.class}"
		end
		fillval
	end

	def set_env_val(name, val)
#		Env[name] = val
	end

	def set
		envs.each { |k, v| set_env_val(k, v) }
	end

	def clear
		envs.each { |k, v| set_env_val(k, "") }
	end

end
