require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlineparser/parse_run_as_sudo'

describe ParseRunAsSudo do
	it_behaves_like "a parser"

	def parser
		ParseRunAsSudo.new
	end

	describe "#parse" do
		context "when args do not contain :run_as_sudo key" do
			let(:args) { {target: "target/path", source: "source/path"} }

			it "should return nil" do
				parser.parse(args).should be_nil
			end
		end

		context "when args contain :run_as_sudo key" do
			context "with a value of true" do
				let(:args) { {target: "target/path", run_as_sudo: "true"} }
				it "should return sudo" do
					parser.parse(args).should eql('sudo')
				end
			end
			context "with a value of trUe" do
				let(:args) { {target: "target/path", run_as_sudo: "trUe"} }
				it "should return sudo" do
					parser.parse(args).should eql('sudo')
				end
			end
			context "with a value of yeS" do
				let(:args) { {target: "target/path", run_as_sudo: "yeS"} }
				it "should return sudo" do
					parser.parse(args).should eql('sudo')
				end
			end
			context "with a value other than true or yes (anycase)" do
				let(:args) { {target: "target/path", run_as_sudo: "bnbdjhfjh"} }
				it "should return nil" do
					parser.parse(args).should be_nil
				end
			end
		end

	end



end
