require 'support/shared_examples_for_cmd_item.rb'
require_relative '../../../../lib/ruplicity/cmd/cmd_item/named_value'

module Ruplicity
	describe CmdItem::NamedValue do
		it_behaves_like "a CmdItem"

		context "given a name" do
		let (:item) do
			item = CmdItem::NamedValue.new
			item.name = "extra-clean"
			item
		end
			
			describe "#switch_str" do
				it "returns a double hyphen switch appended with the value" do
					expect(item.switch_str).to eq("--extra-clean")
				end
			end

			describe "#call" do
				context "when params contain switch symbol" do
					let (:params) { { this: "name", extra_clean: "that" } }

					it "returns a double hyphen switch with the params value appended" do
						expect(item.call(params)).to eq("--extra-clean that")
					end
				end

				context "when params do not contain switch symbol" do
				let(:params) { { this: "name", that: "stuff" } }

				it "returns nil" do
					expect(item.call(params)).to be_nil
				end

				it "does not add an error" do
					item.call params
					expect(item.errors.length).to eql(0)
				end
			end




			end



    end
	end
end
