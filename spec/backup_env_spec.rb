require "spec_helper"

describe "BackupEnv" do
	before(:each) do
		@env = BackupEnv.new
	end

	describe "#check_add_item_args" do
		it "should raise an error if an env var name is not a string" do
			key = 12
			val = "first"
			lambda { @env.check_add_item_args(key, val) }.should raise_error(
				ArgumentError, "The value 12 is not a valid environment var name")
		end

		it "should raise an error if an env var name is the empty string" do
			key = ""
			val = "first"
			lambda { @env.check_add_item_args(key, val) }.should raise_error(
				ArgumentError, "An environment var name cannot be an empty string")
		end

		it "should raise an error if an environment var value is not a string" do
			key = "FIRST"
			val = 12
			lambda { @env.check_add_item_args(key, val) }.should raise_error(
				ArgumentError, "The environment variable #{key} cannot be set with " +
					"the value #{val}, must be a string")
		end
	end

		describe "#check_fill_arg" do
			it "should raise an error if not passed an hash" do
				lambda { @env.check_fill_arg "this" }.should raise_error(
					ArgumentError, "Fill must be passed a hash to fill from not a String")
			end

			it "should return a hash" do
				@env.check_fill_arg({}).should be_a Hash
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

end
