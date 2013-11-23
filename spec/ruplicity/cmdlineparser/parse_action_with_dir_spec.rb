require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlineparser/parse_action_with_dir'

describe ParseActionWithDir do
	it_behaves_like "an action parser"

	let(:parser) { described_class.new }

	before :each do
		@args =  {name: "test", action: "full", dir: "test_dir", url: "test_url"}
	end

	describe "#additional_checks" do
		context "with no dir key" do
			it "should post an error" do
				@args.delete(:dir)
				parser.additional_checks(@args)
				parser.errors.should have(1).error
			end
		end
	end

end
