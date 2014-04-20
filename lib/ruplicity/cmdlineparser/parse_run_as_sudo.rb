require_relative '../set_errors'
require_relative './cmd_parser'

module Ruplicity

	class ParseRunAsSudo < CmdParser

		private

		def normalize_args
			normalize_key :run_as_sudo
		end

		def uses_this_parser?
			@args.has_key? :run_as_sudo
		end

		def check_for_errors
		end

		def run_as_sudo?
			key = @args.fetch(:run_as_sudo, "false").to_s.downcase
			%w(true yes).include?(key)
		end

		def amend_cmd_array(arr)
			run_as_sudo? ? ["sudo"] + arr : arr
		end

	end

end
