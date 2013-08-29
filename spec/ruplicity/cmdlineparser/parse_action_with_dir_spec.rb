require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlineparser/parse_action_with_dir'

describe ParseActionWithDir do
	it_behaves_like "an action parser"

	def parser
		ParseActionWithDir.new
	end



end
