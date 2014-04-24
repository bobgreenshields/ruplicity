require_relative '../set_errors'
require_relative './cmd_builder'

module Ruplicity

	class DirRestore < CmdBuilder

		def self.use_this?(args)
			%w(restore verify).include?(args[:action])
		end

		def uses_this_parser?
			self.class.use_this?(@args)
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
			initial_arr + [ @args[:action] , @args[:options], @args[:url] , @args[:dir] ]
		end

	end

end