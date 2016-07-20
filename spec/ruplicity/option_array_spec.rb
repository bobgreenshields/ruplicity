require 'spec_helper'
require_relative '../../lib/ruplicity/option_array.rb'

TestOpt = Struct.new(:name)

describe OptionArray do

	def populated_array
			opt_array = OptionArray.new
			opts = %i{one two three}.map {|name| TestOpt.new(name)}
			opts.each {|opt| opt_array.push(opt)}
			opt_array
	end

	context "when initialized" do
		it "should contain zero options" do
			opt_array = OptionArray.new
			expect(opt_array.length).to eql(0)
		end
	end
	
	describe "#push" do
		it "should append options to the array" do
			opt_array = populated_array
			expect(opt_array.length).to eql(3)
		end

		it "should return itself" do
			opt_array = OptionArray.new
			test_opt = TestOpt.new(:one)
			expect(opt_array.push(test_opt)).to equal(opt_array)
		end
	end

	describe "#include?" do
		context "when it includes and option with a given name symbol" do
			it "returns true" do
				expect(populated_array.include?(:two)).to be_truthy
			end
		end

		context "when it does not include an option with a given name symbol" do
			it "returns false" do
				expect(populated_array.include?(:four)).to be_falsey
			end
		end
	end

	describe "#replace_or_push" do
		context "when it does not inlcude an option with the same name" do
			let(:test_opt) {TestOpt.new(:four)}
			it "should return itself" do
				opt_array = populated_array
				expect(opt_array.replace_or_push(test_opt)).to equal(opt_array)
			end

			it "should push the option onto the array" do
				opt_array = populated_array
				opt_array.replace_or_push(test_opt)
				expect(opt_array.length).to eql(4)
			end
			
		end

		context "when it inlcudes an option with the same name" do
			let(:test_opt) {TestOpt.new(:one)}
			it "should return itself" do
				opt_array = populated_array
				expect(opt_array.replace_or_push(test_opt)).to equal(opt_array)
			end

			it "should not push the option onto the array" do
				opt_array = populated_array
				opt_array.replace_or_push(test_opt)
				expect(opt_array.length).to eql(3)
			end
			
		end


	end




end
