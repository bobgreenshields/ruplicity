require 'spec_helper'
require_relative '../../lib/ruplicity/cmd'

describe CmdItemBuilder do
	class TestClass
		attr_accessor :name
	end

	subject (:builder) { CmdItemBuilder.new(TestClass, "new name") }

	describe "#call" do
		it "should create an instance of the class it was initialized with" do
			expect(builder.call).to be_a(TestClass)
		end

		it "should create an instance with its name attr set" do
			expect(builder.call.name).to eq("new name")
		end
	end
end
