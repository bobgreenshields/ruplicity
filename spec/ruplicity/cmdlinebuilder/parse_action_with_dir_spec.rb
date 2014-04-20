require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlinebuilder/parse_action_with_dir'

describe ParseActionWithDir do
	it_behaves_like "an action parser"

#	let(:parser) { described_class.new(@args) }
	def parser
#		described_class.new(@args)
		ParseActionWithDir.new(@args)
	end

	before :each do
		@options = ["--dry-run", "--encrypt-key BBBBBBBB"]
		@args =  {name: "test", action: "full", dir: "test_dir", url: "test_url", options: @options}
	end

	describe "#parse" do

		context "with an action of full" do
			it "should return the dir and url" do
				parser.parse(@args).should eql([ @args[:action] ] + @options + [ @args[:dir], 
																																		 @args[:url] ])
			end
		end

		context "with an action of incr" do
			it "should return the dir and url" do
				@args[:action] = "incr"
				parser.parse(@args).should eql([ @args[:action] ] + @options + [ @args[:dir], 
																																		 @args[:url] ])
			end
		end

		context "with an action of verify" do
			it "should return the url and dir" do
				@args[:action] = "verify"
				parser.parse(@args).should eql([ @args[:action] ] + @options + [ @args[:url], 
																																		 @args[:dir]])
			end
		end

		context "with an action of restore" do
			it "should return the url and dir" do
				@args[:action] = "restore"
				parser.parse(@args).should eql([ @args[:action] ] + @options + [ @args[:url], 
																																		 @args[:dir]])
			end
		end

		it "should not return any errors" do
			parser.parse(@args)
				parser.errors.should have(0).error
		end



		context "with no dir key" do
			it "should post an error" do
				@args.delete(:dir)
				parser.parse(@args)
				parser.post_error("this error")
				parser.errors.should have(1).error
			end
		end
	end

end
