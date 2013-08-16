require_relative '../set_errors'

module Ruplicity

	class ParseRunAsSudo
		include SetErrors

		def parse(args)
			run_as_sudo = args.fetch(:run_as_sudo, "false").to_s.downcase
			%w(true yes).include?(run_as_sudo) ? "sudo" : nil
		end
	end

end
