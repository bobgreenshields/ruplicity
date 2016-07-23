require 'forwardable'
require_relative "./option_adder"

class OptionArray
	extend Forwardable

	PREPENDER_NAMES = %i{exclude exclude_device_files exclude_filelist} +
		%i{exclude_regexp include include_filelist include_regexp}

	def_delegators :@option_array, :length, :[], :index

	def initialize
		@option_array = []
		@adders = {}
		load_prependers
	end

	def initialize_options(options)
		options.each {|option| @option_array << option}
		load_adders(options.map(&:name), replacer)
		load_prependers
	end
	
	def add(option)
		if @adders.key?(option.name)
			@adders[option.name].call(@option_array, option)
		else
			appender.call(@option_array, option)
			@adders[option.name] = replacer
		end
		self
	end

	private

	def load_prependers
		load_adders(PREPENDER_NAMES, prepender)
	end

	def load_adders(names, adder)
		names.each {|name| @adders[name] = adder}
	end

	def replacer
		@replacer ||= OptionAdder::Replacer.new
	end

	def appender
		@appender ||= OptionAdder::Appender.new
	end

	def prepender
		@prepender ||= OptionAdder::Prepender.new
	end

end
