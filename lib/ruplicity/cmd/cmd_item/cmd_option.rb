module Ruplicity
	class CmdOption < CmdItem
		def check_for_name(arg_arr)
			if arg_arr.length = 0
				raise ArgumentError, "a CmdOption needs to be passed a name as the first item in the arguments, none found"
	end
	
end
