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

		it "should raise an error if option should have a value" do
			lambda { @opts.add_string_option("exclude") }.should raise_error(
				ArgumentError, "Option exclude can't be added as a string," +
					"it should be passed with a value")
		end
	end

	describe "#add_hash_option" do
		it "should raise an error if zero elements" do
			empty = {}
			lambda { @opts.add_hash_option(empty) }.should raise_error(
				ArgumentError, "Option hash should have one element only")
		end

		it "should raise an error if more than one element" do
			opt = {"one" => "one", "two" => "two"}
			lambda { @opts.add_hash_option({}) }.should raise_error(
				ArgumentError, "Option hash should have one element only")
		end
	end

	describe "#check_add_option_item_args" do
		it "should raise an error if unknown option name" do
			bad_opt_name = "bad"
			lambda { @opts.check_add_option_item_args(bad_opt_name, "this")
				}.should raise_error(ArgumentError,
				"Invalid option name of #{bad_opt_name}")
		end

		it "should raise an error if the name is not a string" do
			bad_opt_name = 12
			lambda { @opts.check_add_option_item_args(bad_opt_name, "this")
				}.should raise_error(ArgumentError,
				"Option name must be a string not value of #{bad_opt_name}")
		end

		it "should raise an error if option needs a value and its not a string" do
			bad_opt_value = 12
			opt_name = "encrypt-key"
			lambda { @opts.check_add_option_item_args(opt_name, bad_opt_value)
				}.should raise_error(ArgumentError,
				"Option #{opt_name} must have a string value not a value of " +
					"#{bad_opt_value}")
		end

		it "should raise an error if option needs a value but given empty string" do
			bad_opt_value = ""
			opt_name = "encrypt-key"
			lambda { @opts.check_add_option_item_args(opt_name, bad_opt_value)
				}.should raise_error(ArgumentError,
				"Option #{opt_name} must have a string value but given empty string")
		end

		it "should not raise an error if option needs no value and its not a string" do
			bad_opt_value = 12
			opt_name = "dry-run"
			lambda { @opts.check_add_option_item_args(opt_name, bad_opt_value)
				}.should_not raise_error
		end
	end

	describe "add_option_item" do
		before( :each ) do
			@name_w_arg = "encrypt-key"
			@name_no_arg = "dry-run"
			@good_val = "1234ABCD"
		end

		it "should convert a nil value into the empty string" do
			@opts.stub(:check_add_option_item_args)
			@opts.should_receive(:check_add_option_item_args).with(@name_w_arg, "")
			@opts.add_option_item(@name_w_arg, "")
		end

		it "should call check_add_option_item_args with name and value" do
			@opts.stub(:check_add_option_item_args)
			@opts.should_receive(:check_add_option_item_args).with(@name_w_arg, @good_val)
			@opts.add_option_item(@name_w_arg, @good_val)
		end

			it "should include the new option after adding" do
				@opts.add_option_item(@name_w_arg, @good_val)
				@opts.should include @name_w_arg
			end

		context "with new and empty options" do
			it "should have a length of zero" do
				@opts.length.should == 0
			end

			it "should have the option in the first position after adding" do
				@opts.add_option_item(@name_w_arg, @good_val).should == 0
				@opts.position(@name_w_arg).should == 0
			end

			it "should have a length of one after adding" do
				@opts.add_option_item(@name_w_arg, @good_val)
				@opts.length.should == 1
			end
		end

		context "with options already added" do
			before( :each ) do
				@opts.add_option_item("dry-run", "")
				@opts.add_option_item("exclude-regexp", "tmp")
				@opts.add_option_item("ignore-errors", "")
			end

			it "should have a length of 3 before adding" do
				@opts.length.should == 3
			end

			it "should have a length of 4 after adding" do
				@opts.add_option_item(@name_w_arg, @good_val)
				@opts.length.should == 4
			end

			it "should have the new option at position 3" do
				@opts.add_option_item(@name_w_arg, @good_val)
				@opts.position(@name_w_arg).should == 3
			end

			it "should not add a duplicate option" do
				@opts.add_option_item("exclude-regexp", "new")
				@opts.length.should == 3
				@opts.position("exclude-regexp").should == 1
				@opts.option_arr[1]["exclude-regexp"].should == "tmp"
			end
		end
	end

end
