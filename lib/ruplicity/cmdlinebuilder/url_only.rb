require_relative '../set_errors'
require_relative './cmd_builder'

module Ruplicity

	class UrlOnly < CmdBuilder

		def self.use_this?(args)
			%w(collection-status list-current-files cleanup).include?(args[:action])
		end
#
#
#		def uses_this_parser?
#			self.class.use_this?(@args)
##			%w(full incr).include?(@args[:action])
#		end
#
		private

		def check_for_errors
			true
		end

		def amend_cmd_array(arr)
			initial_arr = Array(arr)
			initial_arr + [ @args[:action] , @args[:options] , @args[:url] ]
		end

	end

end
