require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlinebuilder/dir_restore'

describe DirRestore do
	it_behaves_like "a cmd_builder"

	def builder
		DirRestore.new(@args)
	end

	before :each do
		@start_array = ["duplicity"]
		@options = "--dry-run --encrypt-key BBBBBBBB"
		@args =  {name: "test", action: "restore", dir: "test_dir", url: "test_url", options: @options}
	end

	def correct_cmd_arr
		@start_array + [ @args[:action], @options, @args[:url], @args[:dir] ]
	end

	describe "#cmd_arr" do
		context "when args contain action restore" do
			it "should append the action, options, dir and url" do
				builder.cmd_arr(["duplicity"]).should eql(correct_cmd_arr)
			end
		end

		context "when args contain action verify" do
			before :each do
				@args[:action] = 'verify'
			end
			it "should append the action, options, dir and url" do
				builder.cmd_arr(["duplicity"]).should eql(correct_cmd_arr)
			end
		end

		context "when args do not contain a :dir" do
			before :each do
				@args.delete(:dir)
				@build = builder
			end

			it "should not change the array passed into it" do
				@build.cmd_arr(["duplicity"]).should eql(["duplicity"])
			end

			it "should post an error" do
				@build.cmd_arr(["duplicity"])
				@build.has_errors?.should be_true
			end
		end
	end
end
