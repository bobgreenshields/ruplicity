require "spec_helper"

describe "BackupPass" do
	before(:each) do
		@pass = BackupPass.new
	end

	describe "#check_add_item_args" do
		it "should raise an error if a passphrase name is not a string" do
			name = 12
			val = "first"
			lambda { @pass.check_add_item_args(name, val) }.should raise_error(
				ArgumentError, "Passphrase name must be a string, not value #{name}")
		end

		it "should raise an error if a passphrase name is the empty string" do
			name = ""
			val = "first"
			lambda { @pass.check_add_item_args(name, val) }.should raise_error(
				ArgumentError, "A passphrase must be one of DEFAULT BACKUP RESTORE, not #{name}")
		end

		it "should raise an error if a passphrase value is not a string" do
			name = "DEFAULT"
			val = 12
			lambda { @pass.check_add_item_args(name, val) }.should raise_error(
				ArgumentError, "The passphrase #{name} cannot be set with " +
				"the value #{val}, must be a string")
		end
	end
			
		describe "#check_fill_arg" do
			it "should not raise an error if passed a string" do
				lambda { @pass.check_fill_arg "this" }.should_not raise_error
			end

			it "should return a DEFAULT hash if passed a string" do
				val = "this"
				@pass.check_fill_arg(val).should == {"DEFAULT" => val}
			end

			it "should not raise an error if passed nil" do
				lambda { @pass.check_fill_arg nil }.should_not raise_error
			end

			it "should return a DEFAULT hash with empty string if passed nil" do
				@pass.check_fill_arg(nil).should == {"DEFAULT" => ""}
			end

			it "should raise an error if not passed a string or hash" do
				lambda { @pass.check_fill_arg 12 }.should raise_error(
					ArgumentError, "Fill must be passed a hash or string to fill from not a Fixnum")
			end

			it "should return a hash" do
				@pass.check_fill_arg({}).should be_a Hash
			end
		end

		describe "#fill" do
			it "should populate with a DEFAULT hash when called with a string" do
				val = "this"
				@pass.fill val
				@pass.should include "DEFAULT"
				@pass["DEFAULT"].should == val
			end
		end

		describe "#passphrase" do
			before( :each ) do
				@actions = [:backup, :restore]
				
			end
			it "should return a hash" do
				@pass.passphrase.should be_a Hash
			end

			context "before it is populated" do
				it "should return an empty hash" do
					@pass.passphrase.should == {}
					@actions.each { |a| @pass.passphrase(a).should == {} }
				end
			end

			context "when it has a DEFAULT value" do
				before(:each) do
					@val = "default"
					@pass.fill @val
				end
				
				context "when it only has a DEFAULT value" do
					it "return that value when called" do
						target = {"PASSPHRASE" => @val}
						@pass.passphrase.should == target
						@actions.each { |a| @pass.passphrase(a).should == target }
					end
				end

				context "when it has values other than DEFAULT" do
					before( :each ) do
						@target = {}
						@fill = {}
						@actions.each do |a|
							astr = a.to_s
							@fill[astr.upcase] = astr
							@target[a] = {"PASSPHRASE" => astr}
						end
						@pass.fill @fill
					end

					it "should return the non-DEFAULT value" do
						@pass.passphrase.should == @target[:backup]
						@actions.each { |a| @pass.passphrase(a).should == @target[a] }
					end
				end
			end
			
		end


end
