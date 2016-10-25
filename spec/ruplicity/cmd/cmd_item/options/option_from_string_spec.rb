require 'ruplicity/cmd/cmd_item/options/option_from_string'
require 'ruplicity/errors'

describe NameSplitter do
	subject(:splitter) { NameSplitter.new }
	describe "#call" do
		context "with a name and a value" do
			let(:opt_str) { "name email-backup" }

			it "returns an array of the name and the value without a preceding space" do
				expect(splitter.call(opt_str)).to eql([:name, "email-backup"])
			end
		end

		context "with just a name" do
			let(:opt_str) { "dry-run" }

			it "returns an array containing the name and an empty string" do
				expect(splitter.call(opt_str)).to eql([:dry_run, ""])
			end
		end

		context "with an empty string" do
			let(:opt_str) { "" }

			it "raises an IncorrectlyFormattedOptionError" do
				expect { splitter.call(opt_str) }.to raise_error(IncorrectlyFormattedOptionError)
			end
			
		end
	end
end

describe LetterSplitter do
	subject(:splitter) { LetterSplitter.new }
	describe "#call" do
		context "with a letter appended with a value" do
			let(:opt_str) { "verror" }

			it "returns an array of the name and the value without a preceding space" do
				expect(splitter.call(opt_str)).to eql([:v, "error"])
			end
		end

		context "with just a single letter" do
			let(:opt_str) { "v" }

			it "raises an IncorrectlyFormattedOptionError" do
				expect { splitter.call(opt_str) }.to raise_error(IncorrectlyFormattedOptionError)
			end
		end

		context "with an empty string" do
			let(:opt_str) { "" }

			it "raises an IncorrectlyFormattedOptionError" do
				expect { splitter.call(opt_str) }.to raise_error(IncorrectlyFormattedOptionError)
			end
		end

		context "with a first letter that is not a valid switch" do
			let(:opt_str) { "ferror" }
			
			it "raises an IncorrectlyFormattedOptionError" do
				expect { splitter.call(opt_str) }.to raise_error(IncorrectlyFormattedOptionError)
			end
		end
	end
end
