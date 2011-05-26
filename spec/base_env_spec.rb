require "spec_helper"

describe "BaseEnv" do
	before(:each) do
		@env = Object.new
		@env.stub(:check_add_item_args)
		@env.extend(BaseEnv)
	end

	describe "#envs" do
		it "should return a Hash" do
			@env.envs.should be_a Hash
		end
	end

	describe "#add_item" do
		before(:each) do
			@name = "ONE"
			@val = "1"
		end

		it "should call check_add_item_args with name and value" do
			@env.should_receive(:check_add_item_args).with(@name, @val)
			@env.add_item(@name, @val)
		end

		it "should add the name and value to envs" do
			@env.add_item(@name, @val)
#			@env.include?(@name).should be_true
			@env.should include @name
			@env[@name].should == @val
		end

		it "should upcase the name" do
			@name_down = @name.downcase
			@env.add_item(@name_down, @val)
			@env.should include @name
		end

		it "should change a nil value to the empty string" do
			@env.add_item(@name, nil)
			@env[@name].should == ""
		end

		it "should not change original val if name set again" do
			@env.add_item(@name, @val)
			@new_val = "newvalue"
			@env.add_item(@name, @new_val)
			@env[@name].should == @val
		end
	end

	describe "#fill" do
		before(:each) do
			@fillval = {"TWO" => "2", "THREE" => "3"}
			@env.stub(:check_fill_arg)
		end

		it "should call check_fill_arg with the fillval" do
			@env.should_receive(:check_fill_arg).with(@fillval).and_return({})
			@env.fill @fillval
		end

		it "should not add anything when called with an empty hash" do
			@env.should_receive(:check_fill_arg).with({}).and_return({})
			@env.fill({})
			@env.envs.should == {}
		end

		it "should call add_item with hash returned from check_fill_arg" do
			@name = "ONE"
			@val = "1"
			@env.should_receive(:check_fill_arg).and_return({@name => @val})
			@env.stub(:add_item)
			@env.should_receive(:add_item).with(@name, @val, @env.envs)
			@env.fill @fillval
		end
		
	end

	context "with another env" do
		before( :each ) do
			@fillval = {"TWO" => "2", "THREE" => "3"}
			@env.stub(:check_fill_arg).and_return(@fillval)
			@env.fill @fillval
			@env2 = Object.new
			@env2.extend(BaseEnv)
			@env2.stub(:check_add_item_args)
		end

		context "with another populated env" do
			before( :each ) do
				@fillval2 = {"ONE" => "one", "TWO" => "two"}
				@env2.stub(:check_fill_arg).and_return(@fillval2)
				@env2.fill @fillval2
			end

			it "should have populated env2" do
				@env2.should include "ONE"
				@env2["ONE"].should == "one"
			end

			describe "#merge" do
				before( :each ) do
					@env.stub(:check_fill_arg).and_return(@env2.envs)
					@env.merge @env2
				end

				it "should not overwrite original values" do
					@env["TWO"].should == "2"
					@env["THREE"].should == "3"
				end

				it "should add new values" do
					@env.should include "ONE"
					@env["ONE"].should == "one"
				end
			end

			describe "#inject" do
				before( :each ) do
					@env.stub(:check_fill_arg).and_return(@env2.envs)
					@env.inject @env2
				end

				it "should add new values" do
					@env.should include "ONE"
					@env["ONE"].should == "one"
				end

				it "should not delete if no new value" do
					@env["THREE"].should == "3"
				end

				it "should overwrite original values with new ones" do
					@env["TWO"].should == "two"
				end
			end
		end

		context "with an empty additional arg" do
			it "env2 should be empty" do
				@env2.envs.should == {}
			end
			describe "#merge" do
				before( :each ) do
					@env.stub(:check_fill_arg).and_return(@env2.envs)
					@env.merge @env2
				end

				it "should not change" do
					@env.envs.should == @fillval
				end
			end
		end

	end
	
end
