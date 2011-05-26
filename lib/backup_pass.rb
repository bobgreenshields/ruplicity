require 'base_env'

class BackupPass

	include BaseEnv

	def initialize
		@passkeys = %w(DEFAULT BACKUP RESTORE)
	end

	def check_add_item_args(name, val)
		unless name.kind_of? String
			raise ArgumentError, "Passphrase name must be a string, not value #{name}"
		end
		unless @passkeys.include? name.upcase
			raise ArgumentError, "A passphrase must be one of #{@passkeys.join(" ")}, not #{name}"
		end
		unless val.kind_of? String
			raise(ArgumentError, "The passphrase #{name} cannot be set with " +
				"the value #{val}, must be a string")
		end
	end

	def check_fill_arg(fillval)
		fillval = "" if fillval.nil?
		fillval = {"DEFAULT" => fillval} if fillval.kind_of? String
		unless fillval.kind_of? Hash
			raise ArgumentError, "Fill must be passed a hash or string to fill from not a #{fillval.class}"
		end
		fillval
	end

	def passphrase(action = :backup)
		case 
		when include?(action.to_s.upcase)
			{"PASSPHRASE" => self[action.to_s.upcase]}
		when include?("DEFAULT")
			{"PASSPHRASE" => self["DEFAULT"]}
		else
			{}
		end
	end

end
