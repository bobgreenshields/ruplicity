require 'ruplicity/cmd/cmd_item/options/option_from_string'
require 'ruplicity/errors'

describe Option::NameSplitter do
	subject(:splitter) { Option::NameSplitter.new }
	describe "#call" do
		context "with a name and a value" do
			let(:opt_str) { "--name email-backup" }

			it "returns an array of the name and the value without a preceding space" do
				expect(splitter.call(opt_str)).to eql(["name", "email-backup"])
			end
		end

		context "with just a name" do
			let(:opt_str) { "--dry-run" }

			it "returns an array containing the name and an empty string" do
				expect(splitter.call(opt_str)).to eql(["dry-run", ""])
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

describe Option::LetterSplitter do
	let(:allowed_switches) { %w(t v) }
	subject(:splitter) { Option::LetterSplitter.new(allowed_switches) }
	describe "#call" do
		context "with a letter appended with a value" do
			let(:opt_str) { "-verror" }

			it "returns an array of the name and the value without a preceding space" do
				expect(splitter.call(opt_str)).to eql(["v", "error"])
			end
		end

		context "with just a single letter" do
			let(:opt_str) { "-v" }

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
			let(:allowed_switches) { %i(t v) }
			subject(:splitter) { Option::LetterSplitter.new(allowed_switches) }
			let(:opt_str) { "-ferror" }
			
			it "raises an IncorrectlyFormattedOptionError" do
				expect { splitter.call(opt_str) }.to raise_error(IncorrectlyFormattedOptionError)
			end
		end
	end
end

describe Option::OptionFromString do
	describe "#new" do
		context "when the option string begins with no dashes" do
			let(:opt_str) { "dry-run" }
			
			it "raises an IncorrectlyFormattedOptionError" do
				expect { Option::OptionFromString.new(opt_str) }.to raise_error(IncorrectlyFormattedOptionError,
				"dry-run: an option must begin with 1 or 2 dashes, this one had 0")
			end
		end

		context "when the option string begins with 3 or more dashes" do
			let(:opt_str) { "---dry-run" }
			
			it "raises an IncorrectlyFormattedOptionError" do
				expect { Option::OptionFromString.new(opt_str) }.to raise_error(IncorrectlyFormattedOptionError,
				"---dry-run: an option must begin with 1 or 2 dashes, this one had 3")
			end
		end
	end

	describe "#name" do
		context "when the name string is a normal option name" do
			let(:opt_str) { "--dry-run" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the name as a symbol" do
				expect(opt.name).to  eql(:dry_run)
			end
		end
		context "when the name string is a single letter switch" do
			let(:opt_str) { "-t15D" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the full word version of the name" do
				expect(opt.name).to  eql(:restore_time)
			end
		end

		context "when the name string is time" do
			let(:opt_str) { "--time 15D" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the mapped version of the name" do
				expect(opt.name).to  eql(:restore_time)
			end
		end
	end

	describe "#value" do
		context "when the name string is a normal option name with no value" do
			let(:opt_str) { "--dry-run" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns an empty string" do
				expect(opt.value).to  eql("")
			end
		end

		context "when the name string is a normal option name with a value" do
			let(:opt_str) { "--encrypt-key 123ABCDE" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the text after the name with no leading spaces" do
				expect(opt.value).to  eql("123ABCDE")
			end
		end

		context "when the name string is a single letter switch" do
			let(:opt_str) { "-t15D" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the text after the first letter" do
				expect(opt.value).to  eql("15D")
			end
		end

		context "when the name string is time" do
			let(:opt_str) { "--time 15D" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the text after the name with no leading spaces" do
				expect(opt.value).to  eql("15D")
			end
		end
	end

	describe "#to_s" do
		context "when the name string is a normal option name with no value" do
			let(:opt_str) { "--dry-run" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns just the option name preceded by dashes" do
				expect(opt.to_s).to  eql("--dry-run")
			end
		end

		context "when the name string is a normal option name with a value" do
			let(:opt_str) { "--encrypt-key 123ABCDE" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the option name followed by the value" do
				expect(opt.to_s).to  eql("--encrypt-key 123ABCDE")
			end
		end

		context "when the name string is a single letter switch" do
			let(:opt_str) { "-t15D" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the full option name followed by the value" do
				expect(opt.to_s).to  eql("--restore-time 15D")
			end
		end

		context "when the name string is time" do
			let(:opt_str) { "--time 15D" }
			subject(:opt) { Option::OptionFromString.new(opt_str) }

			it "returns the mapped option name followed by the value" do
				expect(opt.to_s).to  eql("--restore-time 15D")
			end
		end
	end



end
