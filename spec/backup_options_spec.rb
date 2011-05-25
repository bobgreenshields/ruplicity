require 'spec_helper'

describe BackupOptions do

	before(:each) do
		@opts = BackupOptions.new
	end

	describe "#opt_no_arg?" do
		it "should return false for unknown option" do
			@opts.opt_no_arg?("bad").should == false
		end

		it "should return true for good options" do
			opts = %w(allow-source-mismatch asynchronous-upload dry-run)
			opts.each do | o |
				@opts.opt_no_arg?(o).should == true
			end
		end
	end

	describe "#opt_w_arg?" do
		it "should return false for unknown option" do
			@opts.opt_w_arg?("bad").should == false
		end

		it "should return true for good options" do
			opts = %w(archive-dir encrypt-key exclude exclude-filelist)
			opts.each do | o |
				@opts.opt_w_arg?(o).should == true
			end
		end
	end

	describe "#add_string_option" do
		it "should save a good option" do
			@opts.add_string_option "dry-run"
			@opts.should include("dry-run")
			@opts.position("dry-run").should == 0
		end

		it "should raise an error if called with a bad option" do
			lambda { @opts.add_string_option("bad") }.should raise_error(
				ArgumentError, "bad is an unknown option")
		end

		it "should raise an error if option value missing" do
			lambda { @opts.add_string_option("exclude") }.should raise_error(
				ArgumentError, "Option exclude should be passed with a value")
		end
	end

	describe "#add_hash_option" do
		it "should raise an error if zero elements" do
			lambda { @opts.add_hash_option({}) }.should raise_error(
				ArgumentError, "Option hash should have one element only")
		end

		it "should raise an error if more than one element" do
			pending
			opt = {"one" => "one", "two" => "two"}
			lambda { @opts.add_hash_option({}) }.should raise_error(
				ArgumentError, "Option hash should have one element only")
		end
		
	end

end
