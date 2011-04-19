$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'ruplicity'

describe Ruplicity do
	before(:each) do
		@rup = Ruplicity.new({},{})
	end

	describe "#clean_hash" do
		before(:each) do
			@gdhash = {"source" => "this", "dest" => "that",
				"options" => {"dry-run" => nil, "encryptkey" => "ABC"},
				"env" => {"PASS" => "blaa"}}
		end
		it "leaves correct keys unchanged" do
			@rup.clean_hash(@gdhash).should == @gdhash
		end

		it "removes keys that have nil values" do
			@gdhash["source"] = nil
			@rup.clean_hash(@gdhash).should ==
				{"dest" => "that",
				"options" => {"dry-run" => nil, "encryptkey" => "ABC"},
				"env" => {"PASS" => "blaa"}}
		end

		it "removes keys that have empty strings" do
			@gdhash["dest"] = ""
			@rup.clean_hash(@gdhash).should ==
				{"source" => "this",
				"options" => {"dry-run" => nil, "encryptkey" => "ABC"},
				"env" => {"PASS" => "blaa"}}
		end

		it "should remove non valid keys" do
			@gdhash["new"] = "hello"
			@gdhash["newhash"] = {"this" => "that"}
			@rup.clean_hash(@gdhash).should ==
				{"source" => "this", "dest" => "that",
				"options" => {"dry-run" => nil, "encryptkey" => "ABC"},
				"env" => {"PASS" => "blaa"}}
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

	describe "#initialize" do
		before(:each) do
			conf = {"options" => {"encrypt" => "ABC"}}
			one = {"source" => "home", "dest" => "away",
				"options" => {"dry-run" => nil}}
			two = {"source" => "home", "dest" => "away", "bad" => "no",
				"env" => {"PASS" => "ABC", "sign" => "DEF"}}
			back = {"one" => one, "two" => two}
			@pop = Ruplicity.new(conf, back)
		end

		it "should have converted options to an array" do
			@pop.backup("one")["options"].should be_a Array
		end

		it "should have processed nil options" do
			@pop.backup("one")["options"].should include " --dry-run"
		end

		it "should have merged the config array" do
			@pop.backup("one")["options"].should include " --encrypt ABC"
			@pop.backup("two")["options"].should include " --encrypt ABC"
		end

		it "should have converted env to an array" do
			@pop.backup("two")["env"].should be_a Array
		end

		it "should have created and empty env when missing" do
			@pop.backup("one")["env"].should be_a Array
		end

		it "should have uppercased env keys" do
			@pop.backup("two")["env"].should include "SIGN=DEF"
		end

		it "should have removed bad keys" do
			@pop.backup("two").keys.should_not include "bad"
		end
	end

end
