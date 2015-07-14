module Ruplicity
	class Options
		attr_reader :options

		def initialize(option_array)
			@options = Array(option_array).map &:strip
			@key_lookup = Hash.new { | hash, key | hash[key] = [] }
			load_key_lookup
		end

		def load_key_lookup
			@options.each_with_index do | option, index |
				@key_lookup[key_from_option(option)] << index
			end
		end

		def key_indices(key)
			if @key_lookup.has_key?(key)
				@key_lookup[key]
			else
				[]
			end
		end

		def key_from_option(option)
			match = /--(?<key>\S+)(?:\s+\S+)*$/.match option
			if match
				match[:key].downcase.tr("-", "_").to_sym
			else
				raise ArgumentError, "option #{option} does not have a good format"
			end
		end

		def option_from_key(key)
			option = "--#{key}".downcase.tr("_", "-")
			option << " " << yield if block_given?
			option
		end

		def add(option)
			index_arr = @key_lookup[key_from_option(option)]
			if index_arr.empty?
				@options << option
				index_arr << (@options.length - 1)
			else
				@options[index_arr.last] = option
			end
		end

		def inject_matching_options(keys, arg_hash)
			keys.each do | key |
				if arg_hash.has_key?(key) && block_given?
					add(yield key)
				end
			end
		end
		
	end
	
end
