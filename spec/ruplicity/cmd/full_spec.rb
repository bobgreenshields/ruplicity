require "ruplicity/cmd/full"

describe Cmd::Full do
	subject(:cmd) { Cmd::Full.new }
	describe "#call" do
		context "with correct params" do
			let(:params) { {url:"sftp://uid@other.host/some_dir", folder: "/home/bobg"} }
			let(:expected_array) { ["duplicity", "full", "/home/bobg", "sftp://uid@other.host/some_dir"] }
			it "returns the correct cmd array" do
				expect( cmd.call(params) ).to eql(expected_array)

				
			end
		end
	end
end

