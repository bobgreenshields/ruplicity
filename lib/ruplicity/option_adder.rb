class OptionAdder
	class Replacer
		def call(array, option)
			index = array.index(option)
			raise StandardError, "OptionAdder::Replacer should only ever be called "\
				"when an option with the same name is present.  An option with the "\
				"name #{option.name} could not be found" unless index
			array[index] = option
		end
	end

	class Appender
		def call(array, option)
			array.push(option)
		end
	end

	class Prepender
		def call(array,option)
			array.unshift(option)
		end
	end
end
