require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlinebuilder/normalize_args'

	def norm
		NormalizeArgs.new(args)
	end

describe NormalizeArgs do
	context "when new" do
		let(:args) { {dir: "this/one", action: "run"} }
		it "should return an instance" do
			norm.should_not eql(nil)
		end
	end

	describe '#args' do
		context "when a key is a string" do
			let(:args) { {dir: "this/one", "action"=> "run"} }
			it "should change it to a symbol" do
				norm.args.should include(:action)
			end
		end
		context "when a key is a string containing uppercase" do
			let(:args) { {dir: "this/one", "Action"=> "run"} }
			it "should change it to a lowercase symbol" do
				norm.args.should include(:action)
			end
		end
		context "when a key is a string containing a dash" do
			let(:args) { {dir: "this/one", "dry-run"=> "true"} }
			it "should change it to an underscore symbol" do
				norm.args.should include(:dry_run)
			end
		end
		context "when a value has extra whitespace at end or start" do
			let(:args) { {dir: " this/one  \n", "dry-run"=> "true"} }
			it "should be removed" do
				norm.args.should include(dir: "this/one", dry_run: "true")
			end
		end
		context "when there is a duplicate key" do
			let(:args) { {dir: " this/one  \n", "Action" => "full", action: "incr"} }
			it "should post an error" do
				@norm = norm
				@norm.args.should include(dir: "this/one", action: "incr")
				@norm.has_errors?.should eq(true)
			end
		end
	end

end

