class BackupEnv
	def initialize
		@envs = {}
		@passkeys = %w(default, backup, restore)
		@pass = {}
	end

	def include?(key)
		@envs.key? key
	end

	def pass_include?(key)
		@pass.key? key
	end

	def [](key)
		@envs[key]
	end

	def pass_val(name)
		@pass[name]
	end

	def add_item(env, val)
		unless env.kind_of? String
			raise ArgumentError, "The value #{env} is not a valid environment var name"
		end
		val = "" if val.nil?
		unless val.kind_of? String
			raise(ArgumentError, "The env variable #{env} cannot be set with the " +
				"value #{val}, must be a string")
		end
		key = env.upcase
		@envs[key] = val unless include?(key)
	end

	def add_pass(name, val)
		unless name.kind_of? String
			raise ArgumentError, "The value #{name} is not a valid passphrase name"
		end
		val = "" if val.nil?
		unless val.kind_of? String
			raise(ArgumentError, "The passphrase #{name} cannot be set with the " +
				"value #{val}, must be a string")
		end

		
	end


	def fill(envhash)
		unless envhash.kind_of? Hash
			raise ArgumentError, "A BackupEnv must be filled with a hash"
		end
		envhash.each { |k,v| add_item(k, v) }
	end

	def set_env_value(name, value)
#		ENV[name] = value
	end

	def set
		@envs.each { |k, v| set_env_val(k, v) }
	end

	def clear
		@envs.each { |k, v| set_env_val(k, "") }
	end




end
