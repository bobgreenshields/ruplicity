#require 'support/shared_examples_for_cmd_item.rb'
#require_relative '../../../../lib/ruplicity/cmd/cmd_item/optional_value'
require "ruplicity/cmd/cmd_item/optional_value"


describe CmdItem::OptionalValue do
	it_behaves_like "a CmdItem"

	context "given a name" do
	let (:item) do
		item = CmdItem::OptionalValue.new
		item.name = "extra-clean"
		item
	end
		
		describe "#call" do
			context "when params contains name key" do
				let (:params) { { this: "name", extra_clean: "has value" } }

				it "returns just the names value" do
					expect(item.call(params)).to eq("has value")
				end
			end

			context "when params do not contain switch symbol" do
				let(:params) { { this: "name", that: "stuff" } }

				it "returns nil" do
					expect(item.call(params)).to be_nil
				end
			end
		end
	end
end
