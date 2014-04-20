require_relative './shared_examples_for_set_errors'

shared_examples "a cmd_parser" do
	let(:parser) { described_class.new({}) }

	it_behaves_like "it can set_errors"

	describe "#cmd_arr" do
		specify { parser.should respond_to(:cmd_arr) }
	end
end
