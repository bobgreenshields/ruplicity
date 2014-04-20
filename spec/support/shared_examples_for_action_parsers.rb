#require_relative './shared_examples_for_parsers'

shared_examples "an action parser" do
#	let(:parser) { described_class.new(@shared_parser_args) }
	#
	def parser
		described_class.new(@shared_parser_args)
	end


	it_behaves_like "a parser"

	before :each do
		@options = ["--dry-run", "--encrypt-key BBBBBBBB"]
		@shared_parser_args =  {name: "test", action: "full", dir: "test_dir", url: "test_url", options: @options}
	end

	describe "#parses_this_action?" do
		specify { parser.should respond_to(:parses_this_action?) }
	end

#	let(:@shared_parser_args) { {name: "test", action: "full", dir: "test_dir",
#		url: "test_url"} }

	describe "#parses_this_action?" do
		context "with no action key" do
			it "should post an error" do
				@shared_parser_args.delete(:action)
				parser.parses_this_action?(@shared_parser_args)
				parser.errors.should have(1).error
			end
		end
	end

	describe "#parse" do
		context "with no url key" do
			it "should post an error" do
				@shared_parser_args.delete(:url)
				parser.parse(@shared_parser_args)
				parser.errors.should have(1).error
			end
		end
	end



end
