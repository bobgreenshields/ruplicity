require_relative './shared_examples_for_parsers'

shared_examples "an action parser" do
	let(:parser) { described_class.new }

	it_behaves_like "a parser"

	describe "#parses_this_action?" do
		specify { parser.should respond_to(:parses_this_action?) }
	end
end
