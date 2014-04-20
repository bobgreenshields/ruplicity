require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlineparser/normalize_args'

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
				norm.args.has_key?(:action).should be_true
			end
		end
		context "when a key is a string containing uppercase" do
			let(:args) { {dir: "this/one", "Action"=> "run"} }
			it "should change it to a lowercase symbol" do
				norm.args.has_key?(:action).should be_true
			end
		end
		context "when a key is a string containing a dash" do
			let(:args) { {dir: "this/one", "dry-run"=> "true"} }
			it "should change it to an underscore symbol" do
				norm.args.has_key?(:dry_run).should be_true
			end
		end
		context "when a value has extra whitespace at end or start" do
			let(:args) { {dir: " this/one  \n", "dry-run"=> "true"} }
			it "should be removed" do
				norm.args[:dir].should eql("this/one")
			end
		end
	end

end

