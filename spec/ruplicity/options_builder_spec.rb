require 'spec_helper'
require_relative '../../lib/ruplicity/options_builder'

describe OptionsBuilder do
	describe "#normalise_keys" do
		let (:argb) { OptionsBuilder.new }
		before :each do
			@args = {"name" => "base", FORCE: nil, "Dry-Run" => nil }
		end

		it "should change strings to symbols" do
			argb.normalise_keys(@args).keys[0].should eql(:name)
		end

		it "should downcase symbol names" do
			argb.normalise_keys(@args).keys[1].should eql(:force)
		end

		it "should downcase strings and change - to _" do
			argb.normalise_keys(@args).keys[2].should eql(:dry_run)
		end

		it "should not change any of the values" do
			argb.normalise_keys(@args)[:name].should eql("base")
			argb.normalise_keys(@args)[:force].should eql(nil)
			argb.normalise_keys(@args)[:dry_run].should eql(nil)
		end
	end


	describe "#key_from_opt" do
		let (:argb) { OptionsBuilder.new }

		it "should change any option into a key symbol" do
			argb.key_from_opt("--dry-run").should eql(:dry_run)
		end
	end

	describe "#argless_options_from_keys" do
		let (:argb) { OptionsBuilder.new }
		before :each do
			@args = {name: "new run", dry_run: nil, force: "this", dir: "test_dir", 
						url: "test_url"}
			@opts = ["--this this-val", "--dry-run"]
		end

		it "should prepend an option for a key if not present" do
			args = {name: "new run", dry_run: nil, force: "this", 
					 s3_use_new_style: "that", s3_european_buckets: nil}
			opts = ["--this this-val"]
			expected = %w(--dry-run --force --s3-use-new-style --s3-european-buckets) + opts
			argb.argless_options_from_keys(args, opts).should eql(expected)
		end

		it "should ignore a key if the option is already present" do
			argb.argless_options_from_keys(@args, @opts)[2].should eql("--dry-run")
			argb.argless_options_from_keys(@args, @opts)[0].should eql("--force")
		end
	end

	describe "#options_with_args_from_keys" do
		let (:argb) { OptionsBuilder.new }
		before :each do
			@args = {name: "thisname", verbosity: "8", full_if_older_than: "30days",
				encrypt_key: "ABB12345", sign_key: "ABCDEF12", dry_run: nil}
			@opts = ["--this this-val"]
		end

		it "should return an option for a key if not present" do
			expected = ["--name thisname", "--encrypt-key ABB12345", 
							 "--full-if-older-than 30days", "--sign-key ABCDEF12", 
							 "--verbosity 8"] + @opts
			argb.options_with_args_from_keys(@args, @opts).should eql(expected)
		end

		it "should delete an option if present and prepend value from key" do
			opts = @opts + ["--sign-key 12345678", "--verbosity 3"]
			expected = ["--name thisname",  "--encrypt-key ABB12345", 
							 "--full-if-older-than 30days", "--sign-key ABCDEF12", 
							 "--verbosity 8"] + @opts
			argb.options_with_args_from_keys(@args, opts).should eql(expected)

		end

	end

end
