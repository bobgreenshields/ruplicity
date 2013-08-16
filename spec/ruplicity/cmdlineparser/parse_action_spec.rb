require 'spec_helper'
require_relative '../../../lib/ruplicity/cmdlineparser/parse_action'

describe ParseAction do
	it_behaves_like "an action parser"

	def parser
		ParseAction.new
	end


end
