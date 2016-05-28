require 'support/shared_examples_for_cmd_item.rb'
require_relative '../../../../lib/ruplicity/cmd/cmd_item/cmd_option'

module Ruplicity
	describe CmdOption do
		it_behaves_like "a CmdItem"
	end
end
