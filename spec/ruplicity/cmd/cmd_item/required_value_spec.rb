require 'support/shared_examples_for_cmd_item.rb'
require_relative '../../../../lib/ruplicity/cmd/cmd_item/required_value'

module Ruplicity
	describe CmdItem::RequiredValue do
		it_behaves_like "a CmdItem"

		context "given a name" do
		let (:item) do
			item = CmdItem::RequiredValue.new
			item.name = "url"
			item
		end
			
			describe "#call" do
				context "when params contains name key" do
					let (:params) { { this: "name", url: "has value" } }

					it "returns just the names value" do
						expect(item.call(params)).to eq("has value")
					end
				end

				context "when params do not contain switch symbol" do
					let(:params) { { this: "name", that: "stuff" } }
	
					it "returns nil" do
						expect(item.call(params)).to be_nil
					end

					it "adds an error" do
						item.call params
						expect(item.errors.last).to eq("Ruplicity::CmdItem::RequiredValue " \
							"expected to find a params hash key of :url but was not found")
					end
				end
			end



    end
	end
end
