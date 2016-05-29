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

			describe "#errors" do
				context "when initialized with default" do
					it "is an array" do
						expect(item.errors).to be_a Array
					end
					it "is empty" do
						expect(item.errors).to be_empty
					end
				end

				context "when an error has been added" do
					before :each do
						item.add_error("this error")
					end

					it "has an element" do
						expect(item.errors.length).to eql(1)
					end

					it "includes the error string" do
						expect(item.errors.last).to eq("this error")
					end
				end
			end

			
		end
	end
	
end
