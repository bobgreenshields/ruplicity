require 'spec_helper'
require_relative '../../lib/ruplicity/option_array.rb'

TestOpt = Struct.new(:name)

describe OptionArray do

	def populated_array
			opt_array = OptionArray.new
			opts = %i{one two exclude}.map {|name| TestOpt.new(name)}
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

	describe "#index" do
		context "when the array contains the option with the same name" do
			let(:test_opt) {TestOpt.new(:two)}
			it "returns the index of that option" do
				expect(populated_array.index(test_opt)).to eql(1)
			end
		end

		context "when the array does not contain an option with that name" do
			let(:test_opt) {TestOpt.new(:four)}
			it "returns nil" do
				expect(populated_array.index(test_opt)).to be_nil
			end
		end

		context "when an array contains multiple options with the same name" do
			it "returns the index of the first occurance" do
				opt_array = populated_array
				opt_array.push(TestOpt.new(:two))
				opt_array.push(TestOpt.new(:two))
				expect(opt_array.index(TestOpt.new(:two))).to eql(1)
			end
		end
	end

	describe "#include?" do
		context "when it includes an option with a given name symbol" do
			it "returns true" do
				expect(populated_array.include?(TestOpt.new(:two))).to be_truthy
			end
		end

		context "when it does not include an option with a given name symbol" do
			it "returns false" do
				expect(populated_array.include?(TestOpt.new(:four))).to be_falsey
			end
		end
	end

	describe "#prepend" do
		let(:test_opt) {TestOpt.new(:four)}
		it "should put the option at the start of the array" do
			opt_array = populated_array
			opt_array.prepend test_opt
			expect(opt_array[0]).to equal test_opt
		end

		it "should update the indices for the other options" do
			opt_array = populated_array
			opt_array.prepend test_opt
			expect(opt_array.index(TestOpt.new(:two))).to eql(2)
		end

		it "should add the index of the prepended option" do
			opt_array = populated_array
			opt_array.prepend test_opt
			expect(opt_array.index(TestOpt.new(:four))).to eql(0)
			
		end
		
	end

	describe "#add" do
		context "when an option is on the prepend list" do
			let(:test_opt) {TestOpt.new(:exclude)}
			it "should be added to the start of the array" do
				opt_array = populated_array
				opt_array.add test_opt
				expect(opt_array[0]).to equal(test_opt)
			end

			it "should return itself" do
				opt_array = populated_array
				expect(opt_array.add(test_opt)).to equal(opt_array)
			end
		end

		context "when it does not inlcude an option with the same name" do
			let(:test_opt) {TestOpt.new(:four)}
			it "should return itself" do
				opt_array = populated_array
				expect(opt_array.add(test_opt)).to equal(opt_array)
			end

			it "should push the option onto the array" do
				opt_array = populated_array
				opt_array.add(test_opt)
				expect(opt_array[3]).to equal(test_opt)
			end
			
		end

		context "when it inlcudes an option with the same name" do
			let(:test_opt) {TestOpt.new(:two)}
			it "should return itself" do
				opt_array = populated_array
				expect(opt_array.add(test_opt)).to equal(opt_array)
			end

			it "should not push the option onto the array" do
				opt_array = populated_array
				opt_array.add(test_opt)
				expect(opt_array.length).to eql(3)
			end

			it "should replace the option of the same name" do
				opt_array = populated_array
				opt_array.add(test_opt)
				expect(opt_array[1]).to equal(test_opt)
			end
			
		end


	end




end
