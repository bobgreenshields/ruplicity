require_relative '../set_errors'
require_relative './cmd_builder'

module Ruplicity

	class BuildRunAsSudo < CmdBuilder

		private

		def uses_this_parser?
			@args.has_key? :run_as_sudo
		end

		def check_for_errors
		end

		def run_as_sudo?
			val = @args.fetch(:run_as_sudo, "false").to_s.downcase
			%w(true yes).include?(val)
		end

		def amend_cmd_array(arr)
			run_as_sudo? ? ["sudo"] + arr : arr
		end

	end

end
