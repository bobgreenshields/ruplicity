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

		def initialize
			@cmd_items = self.class.cmd_items_to_build.map &:call
		end
	end

	class CmdItemBuilder
		def initialize(cmd_item_class, name)
			@cmd_item_class = cmd_item_class
			@name = name
		end

		def call
			@cmd_item_class.initialize(@name)
		end
	end
end
