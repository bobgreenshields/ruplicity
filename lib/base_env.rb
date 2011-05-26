module BaseEnv

	def envs
		@envs ||= {}
	end

	def include?(name)
		envs.key? name
	end

	def [](name)
		envs[name]
	end

	def add_item(name, val, target = envs)
		val = "" if val.nil?
		check_add_item_args(name, val)
		key = name.upcase
		target[key] = val unless target.key?(key)
	end

	def fill(fillval, target = envs)
		fillhash = check_fill_arg(fillval)
		fillhash.each { |k, v| add_item(k, v, target) }
	end

	def merge(add_env)
		fill add_env.envs
	end

	def inject(add_env)
		add_hash = {}
		fill(add_env.envs, add_hash)
		add_hash.each { |k, v| envs[k] = v }
	end

end
