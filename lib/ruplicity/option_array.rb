require 'forwardable'

class OptionArray
	extend Forwardable

	PREPEND_OPTIONS = %i{exclude exclude_device_files exclude_filelist exclude_regexp \
		include include_filelist include_regexp }

	def_delegators :@option_array, :length, :[]

	def initialize
		@option_array = []
		@indices = {}
#		@indices = Hash.new {|hash, key| hash[key] = []}
	end

	def build_prepend_lookup
		result = Hash.new (false)
		PREPEND_OPTIONS.each_with_object(result) {|name, hash| hash[name] = true}
	end

	def prepend_lookup
		@prepend_lookup ||= build_prepend_lookup
	end

	def prepend?(option)
		prepend_lookup[option.name]
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
		self
	end

	def prepend_index(option)
		increment_indices
		@indices[option.name] = 0
	end

	def prepend(option)
		@option_array.unshift(option)
		prepend_index(option)
		self
	end

	def replace(option)
		@option_array[index(option)] = option
		self
	end

	def add(option)
		return prepend(option) if prepend?(option)
		if include?(option)
			replace option
		else
			push option
		end
		self
	end
end
