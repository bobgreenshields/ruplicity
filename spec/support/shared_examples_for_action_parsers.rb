require_relative './shared_examples_for_parsers'

shared_examples "an action parser" do
	let(:parser) { described_class.new }

	it_behaves_like "a parser"

	describe "#parses_this_action?" do
		specify { parser.should respond_to(:parses_this_action?) }
	end

	let(:args) { {name: "test", action: "full", dir: "test_dir",
		url: "test_url"} }

	describe "#parses_this_action?" do
		context "with no action key" do
			it "should post an error" do
				args.delete(:action)
				parser.parses_this_action?(args)
				parser.errors.should have(1).error
			end
		end
	end

	describe "#parse" do
		context "with no url key" do
			it "should post an error" do
				args.delete(:url)
				parser.parse(args)
				parser.errors.should have(1).error
			end
		end
	end



end
