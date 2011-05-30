class BackupOptions 

	def initialize
		@options = {}
		@option_arr = []
		@no_arg = %w(allow-source-mismatch asynchronous-upload dry-run
			exclude-device-files exclude-filelist-stdin exclude-other-filesystems
			extra-clean force ftp-passive ftp-regular gio ignore-errors
			include-filelist-stdin no-encryption no-print-statistics null-separator
			old-filenames s3-european-buckets s3-unencrypted-connection
			s3-use-new-style ssh-askpass short-filenames use-agent use-scp version)	

		@w_arg = %w(archive-dir encrypt-key exclude exclude-filelist
			exclude-globbing-filelist exclude-if-present exclude-regexp
			file-to-restore full-if-older-than imap-mailbox gpg-options include
			include-filelist include-globbing-filelist include-regexp log-fd log-file
			name num-retries rename scp-command sftp-command sign-key ssh-options
			tempdir time restore-time time-separator verbosity volsize)
	end

	def opt_no_arg?(opt)
		@no_arg.include? opt.downcase
	end

	def opt_w_arg?(opt)
		@w_arg.include? opt.downcase
	end

	def include?(opt)
		@options.has_key? opt.downcase
	end

	def position(opt)
		@options[opt.downcase]
	end

	def add_string_option(inp_opt)
		opt = inp_opt.downcase
		if opt_w_arg?(opt)
			raise(ArgumentError, "Option #{opt} can't be added as a string," +
				"it should be passed with a value")
		end
		unless opt_no_arg?(opt)
			raise ArgumentError, "#{opt} is an unknown option"
		end
		unless include?(opt)
			@option_arr << opt
			@options[opt] = @option_arr.length - 1
		end
	end

	def add_hash_option(opt_hash)
		unless opt_hash.keys.length == 1
			raise ArgumentError, "Option hash should have one element only"
		end
	end

	def add_option_item(name, val)
		val = "" if val.nil?
	end

	def check_add_option_item_args(name, val)
		unless name.kind_of? String
			raise(ArgumentError, "Option name must be a string not value of #{name}")
		end
		opts = @no_arg + @w_arg
		unless opts.include?(name)
			raise(ArgumentError, "Invalid option name of #{name}")
		end
	end

	
end
