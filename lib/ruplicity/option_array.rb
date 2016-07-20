require 'forwardable'

class OptionArray
	extend Forwardable

	def_delegators :@option_array, :length, :[]

	def initialize
		@option_array = []
		@indices = {}
#		@indices = Hash.new {|hash, key| hash[key] = []}
	end

	def include?(option)
		@indices.key? option.name
	end

	def index(option)
		@indices.fetch(option.name, nil)
	end

	def add_index(option, index)
		@indices[option.name] = index unless include?(option)
	end

	def push_index(option)
		@indices[option.name] = (length - 1) unless include?(option)
	end

	def increment_indices
		updated_hash = {}
		@indices.each {|key, value| updated_hash[key] = value + 1}
		@indices = updated_hash
	end

	def push(option)
		@option_array.push option
		push_index(option)
#		add_index(option, length - 1)
#		@indices[option.name] << (@option_array.length - 1)
		self
	end

	def prepend_index(option)
		increment_indices
		@indices[option.name] = 0
	end

	def prepend(option)
		@option_array.unshift(option)
		prepend_index(option)
#		increment_indices
#		@indices[option.name] = 0
		self
	end

	def replace_or_push(option)
		if include?(option)
		else
			push option
		end
		self
	end
end
