require 'forwardable'

class OptionArray
	extend Forwardable

	def_delegators :@option_array, :length
	def_delegator :@indices, :key?, :include?

	def initialize
		@option_array = []
		@indices = Hash.new {|hash, key| hash[key] = []}
	end

	def push(option)
		@option_array.push option
		@indices[option.name] << (@option_array.length - 1)
		self
	end

	def replace_or_push(option)
		if include?(option.name)
		else
			push option
		end
		self
	end
end
