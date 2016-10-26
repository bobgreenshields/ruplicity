require 'ruplicity/utility'

describe ".to_key" do
	it "returns a symbol" do
		expect(Utility.to_key("this")).to eql(:this)
	end

	context "when the key name contains an uppercase letter" do
		it "downcases the uppercase letter" do
			expect(Utility.to_key("This")).to eql(:this)
		end
	end

	context "when the key name has leading whitespace" do
		it "strips the leading whitespace" do
			expect(Utility.to_key("  this")).to eql(:this)
		end
	end

	context "when the key name has trailing whitespace" do
		it "strips the trailing whitespace" do
			expect(Utility.to_key("this    ")).to eql(:this)
		end
	end

	context "when the key name has a dash" do
		it "replaces the dash with an underscore" do
			expect(Utility.to_key("this-that")).to eql(:this_that)
		end
	end

end

describe ".to_option_string" do
	it "returns a string" do
		expect(Utility.to_option_string(:this)).to eql("--this")
	end

	context "when the key name contains an uppercase letter" do
		it "downcases the uppercase letter" do
			expect(Utility.to_option_string(:This)).to eql("--this")
		end
	end

	context "when the key name has an underscore" do
		it "replaces the underscore with a dash " do
			expect(Utility.to_option_string(:this_that)).to eql("--this-that")
		end
	end

end

