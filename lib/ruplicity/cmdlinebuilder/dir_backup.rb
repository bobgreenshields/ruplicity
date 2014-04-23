require_relative '../set_errors'
require_relative './cmd_builder'

module Ruplicity

	class DirBackup < CmdBuilder

		def self.use_this?(args)
			%w(full incr).include?(args[:action])
		end


		def uses_this_parser?
			self.class.use_this?(@args)
#			%w(full incr).include?(@args[:action])
		end

		private

		def check_for_errors
			unless @args.include?(:dir)
				post_error("#{@args[:action]} needs a dir to work on,"\
									 " none found in argument hash")
			end
		end

		def amend_cmd_array(arr)
			initial_arr = Array(arr)
			initial_arr + [ @args[:action] , @args[:options] , @args[:dir] , @args[:url] ]
		end

	end

end
