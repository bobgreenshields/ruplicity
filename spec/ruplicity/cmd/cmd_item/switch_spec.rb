require 'support/shared_examples_for_cmd_item.rb'
require_relative '../../../../lib/ruplicity/cmd/cmd_item/switch'

module Ruplicity
	describe CmdItem::Switch do
		it_behaves_like "a CmdItem"

		context "given a name" do
		let (:item) do
			item = CmdItem::Switch.new
			item.name = "extra-clean"
			item
		end
			
			describe "#switch_str" do
				it "returns a double hyphen switch" do
					expect(item.switch_str).to eq("--extra-clean")
				end
			end

			describe "#call" do
				context "when params contain switch symbol" do
					let (:params) { { this: "name", extra_clean: "" } }



				end

			end



    end
	end
end
