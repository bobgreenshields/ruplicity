$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'ruplicity'

describe Ruplicity do
	before(:each) do
		@rup = Ruplicity.new({},{})
	end

	describe "#remove_empty_keys" do
		it "leaves populated keys unchanged" do
			full = {"one" => "one", "two" => 2, "three" => {}}
			@rup.remove_empty_keys(full).should == full
		end

		it "removes keys that have nil values" do
			partial = {"one" => "one", "two" => nil, "three" => 2, "four" => nil, "five" => {}}
			answer = {"one" => "one", "three" => 2, "five" => {}}
			@rup.remove_empty_keys(partial).should == answer
		end

		it "removes keys that have empty strings" do
			partial = {"one" => [], "two" => "", "three" => "this", "four" => nil, "five" => {}}
			answer = {"one" => [], "three" => "this", "five" => {}}
			@rup.remove_empty_keys(partial).should == answer
		end

		it "should remove all keys if they are empty" do
			empty = {"one" => nil, "two" => nil, "three" => nil}
			@rup.remove_empty_keys(empty).should == {}
		end
	end

	describe "#convert_env" do
		it "returns an empty array if no env key" do
			@rup.convert_env({"one" => 1}).should == []
		end

		it "returns key=value" do
			backup = {"one" => 1, "env" => {"PASS" => "hello", "PATH" => "here"}}
			@rup.convert_env(backup).length.should == 2
			@rup.convert_env(backup).should include "PASS=hello"
			@rup.convert_env(backup).should include "PATH=here"
		end

		it "uppercases keys" do
			backup = {"one" => 1, "env" => {"pass" => "hello", "PATH" => "here"}}
			@rup.convert_env(backup).length.should == 2
			@rup.convert_env(backup).should include "PASS=hello"
			@rup.convert_env(backup).should include "PATH=here"
		end
	end

	describe "#convert_options" do
		it "returns name option if no options key" do
			@rup.convert_options("test", {"one" => 1}).should == [" --name test"]
		end

		it "adds other options ignoring nils and empty strings" do
			backup = {"one" =>1, "options" => {"silent" => nil, "encrypt" => ""}}
			expected = [" --name test --silent --encrypt"]
			@rup.convert_options("test", backup).length.should == 3
			@rup.convert_options("test", backup).should include " --name test"
			@rup.convert_options("test", backup).should include " --silent"
			@rup.convert_options("test", backup).should include " --encrypt"
		end

		it "adds keys to options" do
			backup = {"one" =>1, "options" => {"silent" => nil, "encrypt" => "yes"}}
			expected = [" --name test --silent --encrypt"]
			@rup.convert_options("test", backup).length.should == 3
			@rup.convert_options("test", backup).should include " --name test"
			@rup.convert_options("test", backup).should include " --silent"
			@rup.convert_options("test", backup).should include " --encrypt yes"
		end
	end

	describe "#merge_backup" do
		before(:each) do
			@config = {"options" => {"encrypt" => "yes"},
				"env" => {"PASS" => "hello", "SIGN" => "this"}}
		end

		it "adds keys from config when they don't exist in backup" do
			@rup.merge_backup(@config, {"one" => 1} ).should ==
				{"options" => {"encrypt" => "yes"},
				"env" => {"PASS" => "hello", "SIGN" => "this"},
				"one" => 1}
		end

		it "removes empty keys from config" do
			conf = {"this" => nil, "that" => {"encrypt" => "yes"}}
			@rup.merge_backup(conf, {} ).should ==
				{"that" => {"encrypt" => "yes"}}
		end

		it "removes empty keys from backup" do
			back = {"this" => nil, "that" => {"encrypt" => "yes"}}
			@rup.merge_backup({}, back ).should ==
				{"that" => {"encrypt" => "yes"}}
		end

		it "adds items from config keys to ones in backup" do
			back = {"one" => 1, "options" => {"this" => "that"},
				"env" => {"NAME" => "bob"}}
			@rup.merge_backup(@config, back ).should ==
				{"options" => {"encrypt" => "yes", "this" => "that"},
				"env" => {"PASS" => "hello", "SIGN" => "this", "NAME" => "bob"},
				"one" => 1}
		end

		it "items from backup overide those from config" do
			back = {"one" => 1, "options" => {"this" => "that", "encrypt" => "no"},
				"env" => {"NAME" => "bob", "PASS" => "bye"}}
			@rup.merge_backup(@config, back ).should ==
				{"options" => {"encrypt" => "no", "this" => "that"},
				"env" => {"PASS" => "bye", "SIGN" => "this", "NAME" => "bob"},
				"one" => 1}
		end
	end

end
