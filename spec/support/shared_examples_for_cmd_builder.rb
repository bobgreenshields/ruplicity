require_relative './shared_examples_for_set_errors'

shared_examples "a cmd_builder" do
	let(:builder) { described_class.new({}) }

	it_behaves_like "it can set_errors"

	describe "#self.use_this?" do
    it "should not raise an error" do
			expect { described_class.use_this?({}) }.not_to raise_error
		end
	end

	describe "#cmd_arr" do
		specify { builder.should respond_to(:cmd_arr) }
	end

end
