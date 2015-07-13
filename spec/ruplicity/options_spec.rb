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

		describe "#options" do
			it "should always return an array" do
				expect(Options.new("--force").options).to be_an(Array)
			end

			it "should strip leading and trailing whitespaces" do
				expect(Options.new(["   --force", "  --sign-key A1234  "]).options).
					to eq(["--force", "--sign-key A1234"])
			end
		end

		describe "key_indices" do
			let(:opt) { Options.new(["--force", "--exclude this", "--sign-key", "--exclude that"]) }
			
			it "should always return an array" do
				expect(opt.key_indices(:force)).to be_an(Array)
			end
			
			it "return an array with the index of the option" do
				expect(opt.key_indices(:sign_key)).to eq([2])
			end
			
			it "return an array with all indices for multiple same options" do
				expect(opt.key_indices(:exclude)).to eq([1,3])
			end
		end

    describe "#add" do
			before(:example) do
				@opt = Options.new(["--force", "--exclude this", "--exclude that", "--sign-key"])
			end

			it "should add a new option to the end of the options array" do
				@opt.add("--dry-run")
				expect(@opt.options.last).to eq("--dry-run")
			end

			it "should locate the index of a new option" do
				@opt.add("--dry_run")
				expect(@opt.key_indices(:dry_run)).to eq([4])
			end

			it "should replace the last occurence of a duplicate option" do
				@opt.add("--exclude another")
				expect(@opt.options[2]).to eq("--exclude another")
			end

			it "should change the indices of a duplicate option" do
				@opt.add("--exclude another")
				expect(@opt.key_indices(:exclude)).to eq([1,2])
			end
    end

	end
	
end
