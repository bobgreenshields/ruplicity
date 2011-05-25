require "spec_helper"

describe "BackupPass" do
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
