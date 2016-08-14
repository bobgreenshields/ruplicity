#require 'spec_helper'
require "ruplicity/option_array"
require "ruplicity/option"
#require_relative '../../lib/ruplicity/option_array.rb'
#require_relative '../../lib/ruplicity/option.rb'

describe OptionArray do

	def pop_array(names)
		res = OptionArray.new
		res.initialize_options(names.map {|name| TestOpt.new(name)})
		res
	end

	def populated_array
		pop_array %i{one two exclude}
	end

	def option_strings
		["--exclude /tmp",
	 	"--rename docs/metal music/metal",
	 	"--progress-rate 5",
	 	"--s3-use-new-style"]
	end

	def options_with_values
		{encrypt_key: "HGHFHLJL",
	 	exclude: "/TMP",
	 	progress_rate: "3",
	 	full_if_older_than: "3M",
	 	include: "this-important-file",
	 	rename: "this-file that-file"}
	end

	def valueless_options
		{dry_run: nil,
	 	progress: "",
	 	force: ""}
	end

	def target
		[
	 	"--rename this-file that-file",
	 	"--include this-important-file",
		"--exclude /TMP",
		"--exclude /tmp",
	 	"--rename docs/metal music/metal",
	 	"--progress-rate 3",
	 	"--s3-use-new-style",
	 	"--dry-run",
	 	"--progress",
	 	"--force",
	 	"--encrypt-key HGHFHLJL",
	 	"--full-if-older-than 3M"
	 	]
		
	end

	def string_options
		option_strings.map {|str| Option::String.new(str)}
	end

	def options
		valueless = valueless_options.keys.map {|key| Option::Valueless.new(key)}
		with_values = []
		options_with_values.each do |key, value|
			with_values << Option::WithValue.new(key, value)
		end
		valueless + with_values
	end

	context "with a properly loaded array" do
		describe "#push to" do
			it "pushes correct option strings to an array" do
				option_array = OptionArray.new
				option_array.initialize_options string_options
				options.inject(option_array) {|array, option| array.add option}
				expect(option_array.to_string_array).to eql(target)
			end
		end
			
	end




end
