class NullLogger
	def initialize
		@absorb = [:info, :debug, :warn, :fatal]
	end

	def method_missing(meth, *args, &blk)
		if @absorb.include? meth
			return nil
		else
			super
		end
	end
end

class Ruplicity
	def initialize(config, backups, logger = nil)
		@logger = logger || NullLogger.new
		@envs_set = []
		@config = clean_hash("config hash", config)
		if @config.has_key?("options") and @config["options"].has_key?("name")
			@config["options"].delete("name")
		end
		@backups = {}
		backups.each { |k,v| @backups[k] = clean_hash(k, v) }
		@backups.each do |k,v|
			temp = merge_backup(@config, v)
			temp["name"] = k
			temp["env"] = convert_env temp
			temp["options"] = convert_options(temp)
			@backups[k] = temp
		end
	end

	def log
		@logger
	end

	def backup(name)
		@backups[name]
	end

	def backup_names
		@backups.keys
	end

	def process_source(val, name)
		val
	end

	alias process_target process_source

	def process_action(val, name)
		@actnoval = %w(cleanup collection-status full incr list-current-files
			verify)
		@actwval = %w(remove-older-than remove-all-but-n-full
			remove-all-inc-of-but-n-full)
		@act = @actnoval + @actwval
		case val
		when String
			process_action_string(val, name)
		when Hash
			process_action_hash(val, name)
		else
			raise(ArgumentError,
				"Backup #{name} has an action value which is not a string or hash")
		end
	end

	def process_action_string(val, name)
		actnoval = %w(cleanup collection-status full incr list-current-files
			verify)
		actwval = %w(remove-older-than remove-all-but-n-full
			remove-all-inc-of-but-n-full)
		valstr = val.chomp.downcase
		case 
		when actnoval.include?(valstr) then valstr
		else
			raise (ArgumentError,
				"Backup #{name} called with an unknown action of #{val}")
		end
	end

	def process_action_hash(val, name)
		actnoval = %w(cleanup collection-status full incr list-current-files
			verify)
		actwval = %w(remove-older-than remove-all-but-n-full
			remove-all-inc-of-but-n-full)
		val.each do |k,v|
			keystr = k.chomp.downcase
			case 
			when actnoval.include?(keystr)
				process_action_string(keystr, name)
			else
				raise (ArgumentError,
					"Backup #{name} called with an unknown action of #{val}")
			end
		end

	end

	def clean_hash(name, backup)
		goodkeys = ["source", "dest", "action", "options", "env", "name", "passphrase"]
		goodactions= %w(cleanup collection-status full incr list-current-files
			remove-older-than remove-all-but-n-full remove-all-inc-of-but-n-full
			verify)
		backup.delete_if do |k,v|
			case
			when v.nil? : true
			when (v.is_a? String and v.length == 0) : true
			when (not goodkeys.include? k ) : true
			else false
			end
		end
		if backup.has_key?("passphrase") and backup["passphrase"].kind_of? String
			backup["passphrase"] = {"default" => backup["passphrase"]}
		end
		if backup.has_key?("action") and 
			(not goodactions.include?(backup["action"]))
				raise ArgumentError,
					"Backup-#{name} has an invalid action of-#{backup["action"]}"
		end
		backup
	end

	def check_action(backup, name)
		action = backup["action"]
		case
		when (action.kind_of? String)
			check_action_string(action, name)
		when (action.kind_of? Hash)
			check_action_hash (action, name)
		else
			raise ArgumentError
		end
#		unless ([String, Hash].include?(backup["action"].class)) 
#			raise ArgumentError
#		end
	end

	def check_action_string(action_string, name)
		goodactionstr = %w(cleanup collection-status full incr list-current-files
			verify)
		unless goodactionstr.include?(action_string)
			raise ArgumentError
		end
	end

	def check_action_hash(action_hash, name)
		goodactionkeys = %w(remove-older-than remove-all-but-n-full
			remove-all-inc-of-but-n-full)
		length = action_hash.keys.length
		if length == 0 or length > 1
			raise ArgumentError
		end
		unless goodactionkeys.include?(action_hash.keys[0])
			raise ArgumentError
		end
	end

	def convert_env(backup)
		res = {}
		backup.fetch("env", {}).each do |k,v|
#			res[k.upcase] = v
			res[k] = v
		end
		res
	end

	def convert_options(backup)
		if not backup.has_key? "name"
			raise ArgumentError, "No name key for #{backup.inspect}"
		end
		res = [" --name #{backup["name"]}"]
		backup.fetch("options", {}).each do |k,v|
			s = " --#{k}"
			s << " #{v}" if v and v.length > 0
			res << s
		end
		res
	end

	def merge_backup(config, backup)
		config.each do |k,v|
			if backup.has_key? k
				backup[k] = config[k].merge(backup[k])
			else
				backup[k] = config[k]
			end
		end
		backup
	end

	def cmd(backup)
		cmdarr = ["duplicity"]
		cmdarr << backup["action"] if backup.has_key?("action")
		cmdarr = cmdarr + backup["options"]
		cmdarr << backup["source"]
		cmdarr << backup["dest"]
		cmdarr.join(" ")
	end

	def log_execution(backup)
		res = execute_cmd backup
		name = backup["name"]
		exitcode = res[:exitcode]
		if exitcode == 0
			log.info("SUMMARY: #{name}: ran successfully")
		else
			log.error("SUMMARY: #{name}: exited with error code #{exitcode}")
		end
		res[:stdout].each_line { |line| log.info("#{name}: #{line}") }
		res[:stderr].each_line { |line| log.error("#{name}: #{line}") }
		res
	end

	def set_env_value(name, value)
		ENV[name.upcase] = value
	end

	def set_env(env_hash)
		@envs_set = []
		env_hash.each do |k, v|
			@envs_set << k
			set_env_value(k, v)
		end
	end

	def reset_env
		@envs_set.each { |name| set_env_value(name, "") }
	end
		

end
