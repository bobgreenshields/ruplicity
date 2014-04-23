require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlinebuilder/dir_backup'

describe DirBackup do
	it_behaves_like "a cmd_builder"

	def builder
		DirBackup.new(@args)
	end

	before :each do
		@start_array = ["duplicity"]
		@options = "--dry-run --encrypt-key BBBBBBBB"
		@args =  {name: "test", action: "full", dir: "test_dir", url: "test_url", options: @options}
	end

	def correct_cmd_arr
		@start_array + [ @args[:action], @options, @args[:dir], @args[:url] ]
	end

	describe "#self.use_this?" do
		context "with an action of full" do
			it "should be true" do
				expect(DirBackup.use_this?(@args)).to be_true
			end
		end
		context "with an action of incr" do
			before :each do
				@args[:action] = 'incr'
			end
			it "should be true" do
				expect(DirBackup.use_this?(@args)).to be_true
			end
		end
		context "with any other action value" do
			before :each do
				@args[:action] = 'verify'
			end
			it "should be true" do
				expect(DirBackup.use_this?(@args)).to be_false
			end
		end
	end

	describe "#cmd_arr" do
		context "when args contain action full" do
			it "should append the action, options, dir and url" do
				builder.cmd_arr(["duplicity"]).should eql(correct_cmd_arr)
			end
		end

		context "when args contain action incr" do
			before :each do
				@args[:action] = 'incr'
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
