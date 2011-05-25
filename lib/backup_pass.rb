class BackupPass
	def initialize
		@passkeys = %w(default, backup, restore)
		@pass = {}
	end

	def include?(name)
		@pass.key? name
	end

	def [](name)
		@pass[name]
	end

	def add_item(name, val)
		unless name.kind_of? String
			raise ArgumentError, "The value #{name} is not a valid passphrase name"
		end
		val = "" if val.nil?
		unless val.kind_of? String
			raise(ArgumentError, "The passphrase #{name} cannot be set with the " +
				"value #{val}, must be a string")
		end
#		key = env.upcase
#		@pass[key] = val unless include?(key)
	end


end
