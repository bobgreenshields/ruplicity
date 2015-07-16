require 'spec_helper'
require_relative '../../lib/ruplicity/cmd'

describe Cmd do
	it "should call cmd items to build and save the results" do
		c1 = Class.new(Cmd) do
			cmd_items_to_build << ->{ "this" }
			cmd_items_to_build << ->{ "that" }
		end
		expect(c1.new.cmd_items).to eq(["this", "that"])
	end

	it "should be able to have different cmd items in different subclasses" do
		c2 = Class.new(Cmd) do
			cmd_items_to_build << ->{ "this" }
		end
		c3 = Class.new(Cmd) do
			cmd_items_to_build << ->{ "that" }
		end
		expect(c2.new.cmd_items).to eq(["this"])
		expect(c3.new.cmd_items).to eq(["that"])
	end
end
