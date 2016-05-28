require 'support/shared_examples_for_cmd_item.rb'
require_relative '../../../lib/ruplicity/cmd/cmd_item'

module Ruplicity
	describe CmdItem do
		context "given a name" do
			let (:item) do
				item = CmdItem.new
				item.name = "extra-clean"
				item
			end

			describe "#symbol_to_find" do
				it "returns a symbol with dashes replaced by underscores" do
					expect(item.symbol_to_find).to eql(:extra_clean)
				end
			end
		end
	end
	
end
