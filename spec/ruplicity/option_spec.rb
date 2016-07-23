require 'spec_helper'
require_relative '../../lib/ruplicity/option.rb'

describe Option::String do
	let(:option) {Option::String.new("--this value info")}
	describe "#name" do
		it "returns a symbol" do
			expect(option.name).to be_a(Symbol)
		end

		it "takes the option but strips the 2 leading dashes" do
			expect(option.name).to eql(:this)
		end

		context "with an option that contains a dash" do
			let(:option) {Option::String.new("--this-that value info")}
			it "replaces it with an underscore in the symbol" do
				expect(option.name).to eql(:this_that)
			end
		end
	end

	describe "#==" do
		it "returns true if the names are the same" do
			similar_option = Option::String.new("--this other values")
			expect(option == similar_option).to be_truthy
		end

		it "returns false if the names are different" do
			different_option = Option::String.new("--that value info")
			expect(option == different_option).to be_falsey
		end
	end

	describe "#to_s" do
		it "returns the string used to create the option" do
				expect(option.to_s).to eql("--this value info")
		end
	end
end

describe Option::Valueless do

	context "when the initializer symbol does not contain a dash" do
		let(:option) {Option::Valueless.new(:this)}

		describe "#name" do
				it "returns the symbol" do
					expect(option.name).to eql(:this)
				end
			end

		describe "#to_s" do
			it "returns the symbol prepended with dashes as a string" do
				expect(option.to_s).to eql("--this")
			end
		end
	end

	context "when the initializer symbol contains an underscore" do
		let(:option) {Option::Valueless.new(:this_that)}

		describe "#name" do
				it "returns the symbol" do
					expect(option.name).to eql(:this_that)
				end
			end

		describe "#==" do
			it "returns true if the names are the same" do
				similar_option = Option::String.new(:this_that)
				expect(option == similar_option).to be_truthy
			end

			it "returns false if the names are different" do
				different_option = Option::String.new(:that_that)
				expect(option == different_option).to be_falsey
			end
		end

		describe "#to_s" do
			it "replaces the underscore with a dash" do
				expect(option.to_s).to eql("--this-that")
			end
		end
	end

	context "when the initializer symbol contains a dash" do
		let(:option) {Option::Valueless.new(:"this-that")}
		describe "#name" do
				it "replaces it with an underscore in the symbol" do
					expect(option.name).to eql(:this_that)
				end
		end

		describe "#to_s" do
			it "also has a dash" do
				expect(option.to_s).to eql("--this-that")
			end
		end
	end

end


describe Option::WithValue do

	context "when the initializer symbol does not contain a dash" do
		let(:option) {Option::WithValue.new(:this, "value info")}

		describe "#name" do
				it "returns the symbol" do
					expect(option.name).to eql(:this)
				end
			end

		describe "#to_s" do
			it "returns the symbol prepended with dashes and appended with the value" do
				expect(option.to_s).to eql("--this value info")
			end
		end
	end

	context "when the initializer symbol contains an underscore" do
		let(:option) {Option::WithValue.new(:this_that, "value info")}

		describe "#name" do
				it "returns the symbol" do
					expect(option.name).to eql(:this_that)
				end
			end

		describe "#to_s" do
			it "replaces the underscore with a dash" do
				expect(option.to_s).to eql("--this-that value info")
			end
		end
	end

	context "when the initializer symbol contains a dash" do
		let(:option) {Option::WithValue.new(:"this-that", "value info")}
		describe "#name" do
				it "replaces it with an underscore in the symbol" do
					expect(option.name).to eql(:this_that)
				end
		end

		describe "#to_s" do
			it "also has a dash" do
				expect(option.to_s).to eql("--this-that value info")
			end
		end
	end

end
