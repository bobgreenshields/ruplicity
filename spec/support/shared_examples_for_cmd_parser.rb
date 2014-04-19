require_relative './shared_examples_for_set_errors'

shared_examples "a cmd_parser" do
	let(:parser) { described_class.new({}) }

	it_behaves_like "it can set_errors"

#	describe "#parse" do
#		specify { parser.should respond_to(:parse) }
#	end
end
