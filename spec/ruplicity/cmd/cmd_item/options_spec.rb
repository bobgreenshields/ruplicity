require 'ruplicity/cmd/cmd_item/options'

describe CmdItem::Options do
	subject (:options) { CmdItem::Options.new }
	describe "#call" do
		context "when params contains an options array" do
			let(:opt_array) { ["--dry-run", "--encrypt-key 1234ABCD", "--name email-backup"] }
			let(:params) { {options: opt_array } }
			it "returns the options in the array" do
				expect(options.call(params)).to eql(opt_array)
			end
		end
	end
	
end
