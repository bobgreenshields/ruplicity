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
		@config = clean_hash("config", config)
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

	def backup(name)
		@backups[name]
	end

	def backup_names
		@backups.keys
	end

	def clean_hash(name, backup)
		goodkeys = ["source", "dest", "action", "options", "env", "name"]
		goodactions = %w(cleanup collection-status full incr list-current-files
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
		if backup.has_key?("action") and 
			(not goodactions.include?(backup["action"]))
				raise ArgumentError,
					"Backup-#{name} has an invalid action of-#{backup["action"]}"
		end
		backup
	end

	def convert_env(backup)
		res = {}
		backup.fetch("env", {}).each do |k,v|
			res[k.upcase] = v
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
			@logger.info("SUMMARY: #{name}: ran successfully")
		else
			@logger.error("SUMMARY: #{name}: exited with error code #{exitcode}")
		end
		res[:stdout].each_line { |line| @logger.info("#{name}: #{line}") }
		res[:stderr].each_line { |line| @logger.error("#{name}: #{line}") }
	end

end
