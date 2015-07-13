module Ruplicity
	class Cmd
		@@cmd_items_to_build = []

		def self.add_cmd_item_to_build(cmd_item_class, name)
			@@cmd_items_to_build << Cmd_Item_Builder.new(cmd_item_class, name)
		end

		def initialize
			@cmd_items = @@cmd_items_to_build.map &:build
		end
	end

	class Cmd_Item_Builder
		def initialize(cmd_item_class, name)
			@cmd_item_class = cmd_item_class
			@name = name
		end

		def build
			@cmd_item_class.initialize(name)
		end
	end
end
