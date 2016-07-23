class Option
	attr_reader :name

	def ==(other_option)
		name == other_option.name
	end
end

class Option
	class String < Option
		NAME_REGEXP = /^\s*-*(?<name>\S+)\s*.*$/

		def initialize(option_string)
			@name = name_from_string(option_string)
			@option_string = option_string
		end

		def name_from_string(option_string)
			match = NAME_REGEXP.match(option_string)
			match[:name].tr("-", "_").to_sym
		end

		def to_s
			@option_string
		end
	end

	class Valueless < Option
		def initialize(key)
			@name = normalize_name(key)
		end

		def normalize_name(key)
			key.to_s.tr("-", "_").to_sym
		end

		def name_as_str
			@name.to_s.tr("_", "-")
		end

		def to_s
			"--#{name_as_str}"
		end
		
	end

	class WithValue < Option::Valueless
		def initialize(key, value)
			super(key)
			@value = value
		end

		def to_s
			"--#{name_as_str} #{@value}"
		end
	end



end
