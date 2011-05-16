require 'spec_helper'
require 'stringio'

describe Ruplicity do

	context "with empty hashes" do
  	before(:each) do
#  		@log = Testlogger.new
#  		@rup = Ruplicity.new({},{}, @log)
  		@rup = Ruplicity.new({},{})
			@gdhash = {"source" => "this", "dest" => "that", "action" => "full", "name" => "gdhash",
				"options" => {"dry-run" => nil, "empty" => "", "encryptkey" => "ABC"},
				"env" => {"PASS" => "blaa", "2nd" => "doom"}}
			@targethash = @gdhash
  	end
  
  	describe "#clean_hash" do
  		it "leaves correct keys unchanged" do
  			@rup.clean_hash("test", @gdhash).should == @targethash
  		end
  
  		it "removes keys that have nil values" do
  			@gdhash["source"] = nil
  			@targethash.delete "source"
  			@rup.clean_hash("test", @gdhash).should == @targethash
  		end
  
  		it "removes keys that have empty strings" do
  			@gdhash["dest"] = ""
  			@targethash.delete "dest"
  			@rup.clean_hash("test", @gdhash).should == @targethash
  		end
  
  		it "should remove non valid keys" do
  			@gdhash["new"] = "hello"
  			@gdhash["newhash"] = {"this" => "that"}
  			@rup.clean_hash("test", @gdhash).should == @targethash
  		end

  		it "should be happy with a missing action key/value" do
  			@gdhash.delete "action"
  			@rup.clean_hash("test", @gdhash).should == @gdhash
  		end

			it "should remove the action key when value is nil" do
				@gdhash["action"] = nil
				@targethash.delete "action"
  			@rup.clean_hash("test", @gdhash).should == @targethash
  		end

			it "should remove the action key when value is empty string" do
				@gdhash["action"] = ""
				@targethash.delete "action"
  			@rup.clean_hash("test", @gdhash).should == @targethash
  		end

			it "should raise an error when it has an invalid action" do
				@gdhash["action"] = "invalid"
  			lambda { @rup.clean_hash("test", @gdhash) }.should raise_error(
  				ArgumentError,
					"Backup-test has an invalid action of-invalid")
  		end

			it "should not raise an error when it has a valid action" do
				gdactions = %w(cleanup collection-status incr list-current-files)
				gdactions.each do |a|
					@gdhash["action"] = a
					lambda { @rup.clean_hash("test", @gdhash) }.should_not raise_error
				end
  		end

  		it "should convert a passphrase string into a hash with default key" do
  			@gdhash["passphrase"] = "mypassword"
  			@rup.clean_hash("test", @gdhash)["passphrase"].should be_a Hash
  			
  		end
  	end
  
  	describe "#convert_env" do
  		it "returns an empty hash if no env key" do
  			@gdhash.delete "env"
  			@rup.convert_env(@gdhash).should be_a Hash
  			@rup.convert_env(@gdhash).keys.length.should == 0
  		end
  
  		it "returns key value hash" do
  			@rup.convert_env(@gdhash).should be_a Hash
  			@rup.convert_env(@gdhash).keys.length.should == 2
  			@rup.convert_env(@gdhash).keys.should include "PASS"
  			@rup.convert_env(@gdhash).keys.should include "2nd"
  			@rup.convert_env(@gdhash)["PASS"].should == "blaa"
  			@rup.convert_env(@gdhash)["2nd"].should == "doom"
  		end
  
#  		it "uppercases keys" do
#  			@gdhash = {"one" => 1, "env" => {"pass" => "hello", "PATH" => "here"}}
#  			@rup.convert_env(@gdhash).keys.length.should == 2
#  			@rup.convert_env(@gdhash).keys.should include "PATH"
#  			@rup.convert_env(@gdhash).keys.should include "PASS"
#  			@rup.convert_env(@gdhash).keys.should_not include "pass"
#  		end
  	end
  
  	describe "#convert_options" do
  		it "should raise ArgumentError if no name key" do
  			@gdhash.delete "name"
  			lambda { @rup.convert_options(
  				@gdhash) }.should raise_error ArgumentError
  		end

  		it "returns name option if no options key" do
  			@gdhash.delete "options"
  			@rup.convert_options(
  				@gdhash).should == [" --name gdhash"]
  		end
  
  		it "adds options interpreting nils and empty strings as no value" do
  			@rup.convert_options(@gdhash).length.should == 4
  			@rup.convert_options(@gdhash).should include " --name gdhash"
  			@rup.convert_options(@gdhash).should include " --dry-run"
  			@rup.convert_options(@gdhash).should include " --empty"
  		end
  
  		it "adds values to options" do
  			@rup.convert_options(@gdhash).length.should == 4
  			@rup.convert_options(@gdhash).should include " --encryptkey ABC"
  		end
  	end
  
  	describe "#merge_backup" do
  		before(:each) do
  			@config = { "options" => {"encryptkey" => "DEF"},
  				"env" => {"PASS" => "hello", "SIGN" => "this"},
  				"passphrase" => {"default" => "mypassword"}}
  		end

  		it "should return a hash" do
  			@rup.merge_backup(@config, @gdhash ).should be_a Hash
  		end
  
  		it "adds keys from config when they don't exist in backup" do
  			@gdhash.delete "env"
  			@rup.merge_backup(@config, @gdhash )["env"].has_key?("PASS").should be_true
  			@rup.merge_backup(@config, @gdhash )["env"]["PASS"].should == "hello"
  			@rup.merge_backup(@config, @gdhash )["env"].has_key?("SIGN").should be_true
  			@rup.merge_backup(@config, @gdhash )["env"]["SIGN"].should == "this"
  		end
  
  		it "adds items from config keys to ones in backup" do
  			@rup.merge_backup(@config, @gdhash )["env"].has_key?("SIGN").should be_true
  			@rup.merge_backup(@config, @gdhash )["env"]["SIGN"].should == "this"
  		end
  
  		it "adds new hashes" do
  			@rup.merge_backup(@config, @gdhash )["passphrase"].has_key?("default").should be_true
  			@rup.merge_backup(@config, @gdhash )["passphrase"]["default"].should == "mypassword"
  		end
  
  		it "items from backup overide those from config" do
  			@rup.merge_backup(@config, @gdhash )["env"].has_key?("PASS").should be_true
  			@rup.merge_backup(@config, @gdhash )["env"]["PASS"].should == "blaa"
  			@rup.merge_backup(@config, @gdhash )["options"].has_key?("encryptkey").should be_true
  			@rup.merge_backup(@config, @gdhash )["options"]["encryptkey"].should == "ABC"
  		end
 	end



#			@gdhash = {"source" => "this", "dest" => "that", "action" => "full", "name" => "gdhash",
#				"options" => {"dry-run" => nil, "empty" => "", "encryptkey" => "ABC"},
#				"env" => {"PASS" => "blaa", "2nd" => "doom"}}


  	describe "#cmd" do
  		context "with options hash processed into an array" do
				before(:each) do
					@opts = [" --name one", " --encrypt-key ABC", "--dry-run"]
					@gdhash["options"] = @opts
	#  			@back = {"source" => "here", "dest" => "there", "action" => "incr",
	#  				"options" => @opts,
	#  				"env" => {"PASS" => "hello"} }
				end

				subject { @rup.cmd(@gdhash) }

				it { should be_a String }

	#  		context "with its result split into words" do
	#				context "with an action specified" do
	#					before(:each) do
	#						@cmdwords = @rup.cmd(@back).split
	#					end
	#
	#					it "should have duplicity as its first word" do
	#						@cmdwords[0].should == "duplicity"
	#					end
	#
	#					it "should have the action as its second word" do
	#						@cmdwords[1].should == "incr"
	#					end
	#
	#					it "should have the options after its second word" do
	#						@cmdwords[2..6].should == ["--name", "one", "--encrypt-key",
	#							"ABC", "--dry-run"]
	#					end
	#
	#					it "should have the source as its next to last word" do
	#						@cmdwords[-2].should == "here"
	#					end
	#
	#					it "should have the dest as its last word" do
	#						@cmdwords[-1].should == "there"
	#					end
	#				end
	#
	#				context "with no action specified" do
	#					before(:each) do
	#						@back.delete "action"
	#						@cmdwords = @rup.cmd(@back).split
	#					end
	#
	#					it "should have duplicity as its first word" do
	#						@cmdwords[0].should == "duplicity"
	#					end
	#
	#					it "should have the options after its first word" do
	#						@cmdwords[1..5].should == ["--name", "one", "--encrypt-key",
	#							"ABC", "--dry-run"]
	#					end
	#
	#					it "should have the source as its next to last word" do
	#						@cmdwords[-2].should == "here"
	#					end
	#
	#					it "should have the dest as its last word" do
	#						@cmdwords[-1].should == "there"
	#					end
	#				end
	#			end
			end
  	end

#  	describe "#log_execution" do
#  		before(:each) do
#				@back = {"name" => "test", "source" => "this", "dest" => "that"}
#				@res = {:exitcode => 0,
#					:stdout => StringIO.new("out\nsecond\nthird"),
#					:stderr => StringIO.new("err\nsecond\nthird")
#				}
#			end
#
#			context "with a zero exitcode" do
#				it "should call execute_cmd" do
#					@rup.stub(:execute_cmd).and_return(@res)
#					@rup.should_receive(:execute_cmd)
#					@rup.log_execution(@back)
#				end
#
#				it "should have logged a summary to info" do
#					@rup.stub(:execute_cmd).and_return(@res)
#					@rup.log_execution(@back)
#					@log.infolog.length.should == 4
#					@log.infolog[0].should match /SUMMARY: test:/
#					@log.infolog[1].should match /^test: out/
#				end
#			end
#
#			context "with a non-zero exitcode" do
#				before(:each) do
#					@res[:exitcode] = 1
#				end
#
#				it "should call execute_cmd" do
#					@rup.stub(:execute_cmd).and_return(@res)
#					@rup.should_receive(:execute_cmd)
#					@rup.log_execution(@back)
#				end
#
#				it "should have logged a summary to error" do
#					@rup.stub(:execute_cmd).and_return(@res)
#					@rup.log_execution(@back)
#					@log.errorlog[0].should match /SUMMARY: test:.*error code 1$/
#					@log.errorlog[1].should match /^test: err/
#					@log.errorlog.length.should == 4
#				end
#			end
#
#  	end
#	end
#
#
#	context "when created with populated hashes" do
#		before(:each) do
#			@conf = {"options" => {"encrypt" => "ABC"}}
#			one = {"source" => "home", "dest" => "away",
#				"options" => {"dry-run" => nil}}
#			two = {"source" => "home", "dest" => "away", "bad" => "no",
#				"env" => {"PASS" => "ABC", "sign" => "DEF"}}
#			@back = {"one" => one, "two" => two}
#		end
#
#		context "with invalid config hash" do
#			before(:each) do
#				@conf["options"]["name"] = "badname"
#				@pop = Ruplicity.new(@conf, @back)
#			end
#
#			describe "#initialize" do
#				it "should not allow config to overwrite the name" do
#					@conf["options"]["name"] = "config"
#					@pop.backup_names.should include "one"
#					@pop.backup_names.should include "two"
#				end
#			end
#		end
#
#		context "with valid hashes" do
#			before(:each) do
#				@pop = Ruplicity.new(@conf, @back)
#			end
#
#			describe "#initialize" do
#				it "should have converted options to an array" do
#					@pop.backup("one")["options"].should be_a Array
#				end
#		
#				it "should have processed nil options" do
#					@pop.backup("one")["options"].should include " --dry-run"
#				end
#		
#				it "should have merged the config array" do
#					@pop.backup("one")["options"].should include " --encrypt ABC"
#					@pop.backup("two")["options"].should include " --encrypt ABC"
#				end
#		
#				it "should have created an empty env when missing" do
#					@pop.backup("one").keys.should include "env"
#					@pop.backup("one")["env"].should be_a Hash
#					@pop.backup("one")["env"].keys.length.should == 0
#				end
#		
#				it "should have uppercased env keys" do
#					@pop.backup("two")["env"].keys.should include "SIGN"
#					@pop.backup("two")["env"].keys.should_not include "sign"
#				end
#		
#				it "should have removed bad keys" do
#					@pop.backup("two").keys.should_not include "bad"
#				end
#			end
#  	end

	end

end
