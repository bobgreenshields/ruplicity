class Ruplicity
	def initialize(config, backups, logger = nil)
	end

	def remove_empty_keys(backup)
		backup.delete_if { |k,v| v.nil? or (v.is_a? String and v.length == 0) }
	end

	def convert_env(backup)
		res = []
		backup.fetch("env", {}).each do |k,v|
			res << "#{k.upcase}=#{v}"
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

	def merge_backup(dirtyconfig, dirtybackup)
		config = remove_empty_keys dirtyconfig
		backup = remove_empty_keys dirtybackup
		config.each do |k,v|
			if backup.has_key? k
				backup[k] = config[k].merge(backup[k])
			else
				backup[k] = config[k]
			end
		end
		backup
	end

end
