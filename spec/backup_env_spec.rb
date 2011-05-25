require "spec_helper"

describe "BackupEnv" do
	before(:each) do
		@env = BackupEnv.new
	end

	describe "#add_item" do
		it "should add a pair to the hash" do
			key = "FIRST"
			val = "this"
			@env.add_item(key, val)
			@env.should include key
			@env[key].should == val
		end

		it "should capitalise the environment variable name" do
			key = "first"
			capkey = "FIRST"
			val = "this"
			@env.add_item(key, val)
			@env.should include capkey
			@env[capkey].should == val
		end

		it "should not add to an env var a second time" do
			key = "FIRST"
			val = "first"
			val2 = "second"
			@env.add_item(key, val)
			@env.add_item(key, val2)
			@env.should include key
			@env[key].should == val
		end

		it "should raise an error if an env var name is not a string" do
			key = 12
			val = "first"
			lambda { @env.add_item(key, val) }.should raise_error(
				ArgumentError, "The value 12 is not a valid environment var name")
		end

		it "should convert a nil value into an empty string value" do
			key = "FIRST"
			val = nil
			@env.add_item(key, val)
			@env.should include key
			@env[key].should == ""
		end

		it "should raise an error if an env var value is not a string" do
			key = "FIRST"
			val = 12
			lambda { @env.add_item(key, val) }.should raise_error(
				ArgumentError, "The env variable #{key} cannot be set with the value #{val}, must be a string")
		end

	end

		describe "#fill" do
			it "should raise an error if not passed an hash" do
				lambda { @env.fill "this" }.should raise_error(
					ArgumentError)
			end

			it "should call add_item for each element" do
				@env.stub(:add_item)
				@env.should_receive(:add_item).exactly(3).times
				h = {"one" => "one", "two" => "two", "three" => "three"}
				@env.fill h
			end
			
			it "should call add_item with the name and value" do
				@env.stub(:add_item)
				name = "first"
				val = "firstval"
				@env.should_receive(:add_item).with(name, val)
				h = {name => val}
				@env.fill h
			end
		end

		describe "#set" do
			before(:each) do
				@env.stub(:set_env_value)
			end
			
			it "should call set_env_val for each element" do
				h = {"one" => "1", "two" => "2", "three" => "3"}
				@env.fill h
				@env.should_receive(:set_env_val).exactly(3).times
				@env.set
			end

			it "should call set_env_val with the name and value" do
				name = "FIRST"
				val = "firstval"
				h = {name => val}
				@env.fill h
				@env.should_receive(:set_env_val).with(name, val)
				@env.set
			end
		end
	
		describe "#clear" do
			before(:each) do
				@env.stub(:set_env_value)
			end
			
			it "should call set_env_val for each element" do
				h = {"one" => "1", "two" => "2", "three" => "3"}
				@env.fill h
				@env.should_receive(:set_env_val).exactly(3).times
				@env.clear
			end

			it "should call set_env_val with an empty string" do
				name = "FIRST"
				val = "firstval"
				h = {name => val}
				@env.fill h
				@env.should_receive(:set_env_val).with(name, "")
				@env.clear
			end
		end

		describe "#add_pass" do
		it "should raise an error if a passphrase name is not a string" do
			key = 12
			val = "first"
			lambda { @env.add_pass(key, val) }.should raise_error(
				ArgumentError, "The value 12 is not a valid passphrase name")
		end

		it "should convert a nil value into an empty string value" do
			key = "FIRST"
			val = nil
			@env.add_pass(key, val)
			@env.pass_include?(key).should be_true
#			@env.should pass_include key
			@env.pass_val(key).should == ""
		end

		it "should raise an error if an passphrase value is not a string" do
			key = "restore"
			val = 12
			lambda { @env.add_pass(key, val) }.should raise_error(
				ArgumentError, "The passphrase #{key} cannot be set with the value #{val}, must be a string")
		end
			
		end
end
