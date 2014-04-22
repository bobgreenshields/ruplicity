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

	describe "#cmd_arr" do
		context "when args contain action full" do
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

#		context "when args do not contain :run_as_sudo key" do
#			let(:args) { {target: "target/path", source: "source/path"} }
#
#			it "should return the array passed in" do
#				builder.cmd_arr(start_arr).should eql(start_arr)
#			end
#		end
#
#		context "when args contain :run_as_sudo key" do
#			context "with a value of true" do
#				let(:args) { {target: "target/path", run_as_sudo: "true"} }
#				it "should return sudo" do
#					builder.cmd_arr(start_arr).should eql(prep_arr)
#				end
#			end
#			context "with a value of trUe" do
#				let(:args) { {target: "target/path", run_as_sudo: "trUe"} }
#				it "should return sudo" do
#					builder.cmd_arr(start_arr).should eql(prep_arr)
#				end
#			end
#			context "with a value of yeS" do
#				let(:args) { {target: "target/path", run_as_sudo: "yeS"} }
#				it "should return sudo" do
#					builder.cmd_arr(start_arr).should eql(prep_arr)
#				end
#			end
#			context "with a value other than true or yes (anycase)" do
#				let(:args) { {target: "target/path", run_as_sudo: "bnbdjhfjh"} }
#				it "should return the array passed in" do
#					builder.cmd_arr(start_arr).should eql(start_arr)
#				end
#			end
#		end
#
#
#
	end
end
