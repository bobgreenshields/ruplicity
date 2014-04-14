require_relative '../set_errors'

module Ruplicity

	class ParseRunAsSudo
		include SetErrors

		def initialize(args)
			@args = args
		end

		def cmd_arr(arr)
			run_as_sudo? ? ["sudo"] + arr : arr
		end

#		def parse(args)
#			run_as_sudo = args.fetch(:run_as_sudo, "false").to_s.downcase
#			%w(true yes).include?(run_as_sudo) ? "sudo" : nil
#		end

		private

		def run_as_sudo?
			key = @args.fetch(:run_as_sudo, "false").to_s.downcase
			%w(true yes).include?(key)
		end
	end

end
