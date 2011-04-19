class Ruplicity
	def initialize(config, backups, log = nil)
		@config = clean_hash(config)
		@backups = {}
		backups.each { |k,v| @backups[k] = clean_hash v }
		@backups.each do |k,v|
			temp = merge_backup(@config, v)
			temp["env"] = convert_env temp
			temp["options"] = convert_options(k, temp)
			@backups[k] = temp
		end
	end

	def backup(name)
		@backups[name]
	end

	def clean_hash(backup)
		goodkeys = ["source", "dest", "options", "env"]
		backup.delete_if do |k,v|
			case
			when v.nil? : true
			when (v.is_a? String and v.length == 0) : true
			when (not goodkeys.include? k ) : true
			else false
			end
		end
	end

	def convert_env(backup)
		res = {}
		backup.fetch("env", {}).each do |k,v|
			res[k.upcase] = v
		end
		res
	end

	def convert_options(name, backup)
		res = [" --name #{name}"]
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
		cmdarr = cmdarr + backup["options"]
		cmdarr << backup["source"]
		cmdarr << backup["dest"]
		cmdarr.join(" ")
	end

end
