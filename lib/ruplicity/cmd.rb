module Ruplicity

	class Cmd

		class << self
			def cmd_items_to_build
				@cmd_items_to_build ||= []
			end
			
			def add_cmd_item_to_build(cmd_item_class, name)
				cmd_items_to_build << CmdItemBuilder.new(cmditemclass, name)
			end
		end

		attr_reader :cmd_items, :errors

		def initialize(errors: [])
			@errors = errors
			build_cmd_items
		end

		def build_cmd_items
			@cmd_items = self.class.cmd_items_to_build.map { |item| item.call(@errors) }
		end
	end

	class CmdItemBuilder
		def initialize(cmd_item_class, name)
			@cmd_item_class = cmd_item_class
			@name = name
		end

		def call(errors)
			cmd_item = @cmd_item_class.new(errors: errors)
			cmd_item.name = @name
			cmd_item
		end
	end

end
