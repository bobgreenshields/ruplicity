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

def add_item(name, val)
	val = "" if val.nil?
	check_add_item_args(name, val)
	key = name.upcase
	envs[key] = val unless include?(key)
end

def fill(fillval)
	fillhash = check_fill_arg(fillval)
	fillhash.each { |k, v| add_item(k, v) }
end

end
