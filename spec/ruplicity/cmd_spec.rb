#require 'spec_helper'
require "ruplicity/cmd"
#require_relative '../../lib/ruplicity/cmd'

class ItemTester
	attr_reader :errors, :name
	def initialize(name)
		@name = name
		@called = false
		@errors = nil
	end

	def called?
		@called
	end

	def call(errors)
		@errors = errors
		@called = true
		self
	end
end

describe Cmd do
	c1 = Class.new(Cmd) do
		cmd_items_to_build << ItemTester.new("first")
		cmd_items_to_build << ItemTester.new("second")
	end

	it "calls cmd items to build and saves the results" do
		expect(c1.new.cmd_items.first).to be_called
	end

	it "calls cmd items in the correct order" do
		expect(c1.new.cmd_items.first.name).to eq("first")
		expect(c1.new.cmd_items.last.name).to eq("second")
	end

	it "passes its error handler to the cmd items" do
		expect(c1.new.cmd_items.first.errors).to be_an Array
	end

	context "with different cmd subclasses" do
		c2 = Class.new(Cmd) do
			cmd_items_to_build << ItemTester.new("different")
		end

		it "has different CmdItems" do
			expect(c1.new.cmd_items.first.name).to eq("first")
			expect(c2.new.cmd_items.first.name).to eq("different")
		end
	end

	describe ".action_name" do
		context "when a subclass has not defined the action name" do
			class Cmd
				class Full < Cmd
				end
			end
				it "returns the subclass name downcased" do
					expect(Cmd::Full.action_name).to eql("full")
				end
		end		

		context "when a subclass has called action to define the name" do
			class Cmd
				class FullIfOlder < Cmd
					action "full-if-older-than"
				end
			end

			it "returns the value that action was called with" do
				expect(Cmd::FullIfOlder.action_name).to eql("full-if-older-than")
			end
		end

		context "when a subclass is not in the Cmd class namespace" do
			class Incremental < Cmd
			end

			it "raises a standard error" do
				expect{ Incremental.action_name }.to raise_error(StandardError)
			end
		end
	end

end
