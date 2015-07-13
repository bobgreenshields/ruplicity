require 'spec_helper'
require_relative '../../lib/ruplicity/options.rb'

describe Options do
	describe "#key_from_option" do
		let(:opt) { Options.new([]) }

		it "should return a symbol" do
			expect(opt.key_from_option("--dry-run")).to be_a(Symbol)
		end

		it "removes the dashes from the start of the option" do
			expect(opt.key_from_option("--force")).to eq(:force)
		end

		it "swaps between word dashes for underscores" do
			expect(opt.key_from_option("--dry-run")).to eq(:dry_run)
		end

		it "downcases the string" do
			expect(opt.key_from_option("--FoRcE")).to eq(:force)
		end

		it "ignores any values" do
			expect(opt.key_from_option("--sign-key A12345BCF")).to eq(:sign_key)
		end

		it "raises an error if not prepended with --" do
			expect { opt.key_from_option("force") }.
				to raise_error(ArgumentError, "option force does not have a good format")
		end

	end
	
end
