require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlinebuilder/url_only'

describe UrlOnly do
	it_behaves_like "a cmd_builder"

	def builder
		UrlOnly.new(@args)
	end

	before :each do
		@start_array = ["duplicity"]
		@options = "--dry-run --encrypt-key BBBBBBBB"
		@args =  {name: "test", action: "full", dir: "test_dir", url: "test_url", options: @options}
	end

	def correct_cmd_arr
		@start_array + [ @args[:action], @options, @args[:url] ]
	end

	describe "#self.use_this?" do
		context "with an action of collection_status" do
			before :each do
				@args[:action] = 'collection-status'
			end
			it "should be true" do
				expect(UrlOnly.use_this?(@args)).to be_true
			end
		end
		context "with an action of list-current-files" do
			before :each do
				@args[:action] = 'list-current-files'
			end
			it "should be true" do
				expect(UrlOnly.use_this?(@args)).to be_true
			end
		end
		context "with an action of cleanup" do
			before :each do
				@args[:action] = 'cleanup'
			end
			it "should be true" do
				expect(UrlOnly.use_this?(@args)).to be_true
			end
		end
		context "with any other action value" do
			before :each do
				@args[:action] = 'xxxx'
			end
			it "should be false" do
				expect(UrlOnly.use_this?(@args)).to be_false
			end
		end
	end

	describe "#cmd_arr" do
		context "when args contain action cleanup" do
			before :each do
				@args[:action] = 'cleanup'
			end
			it "should append the action, options and url" do
				builder.cmd_arr(["duplicity"]).should eql(correct_cmd_arr)
			end
		end
#
#		context "when args contain action incr" do
#			before :each do
#				@args[:action] = 'incr'
#			end
#			it "should append the action, options, dir and url" do
#				builder.cmd_arr(["duplicity"]).should eql(correct_cmd_arr)
#			end
#		end
#
#		context "when args do not contain a :dir" do
#			before :each do
#				@args.delete(:dir)
#				@build = builder
#			end
#
#			it "should not change the array passed into it" do
#				@build.cmd_arr(["duplicity"]).should eql(["duplicity"])
#			end
#
#			it "should post an error" do
#				@build.cmd_arr(["duplicity"])
#				@build.has_errors?.should be_true
#			end
#		end
	end
end
