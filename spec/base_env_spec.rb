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

		it "should call add_item with hash returned from check_fill_arg" do
			@name = "ONE"
			@val = "1"
			@env.should_receive(:check_fill_arg).and_return({@name => @val})
			@env.stub(:add_item)
			@env.should_receive(:add_item).with(@name, @val)
			@env.fill @fillval
		end
		
	end
	
end
