require 'spec_helper'
require_relative '../../lib/ruplicity/options_cleaner'

describe OptionsCleaner do
	let(:cln) { OptionsCleaner.new }
	before :each do
		@opts = ["--name Hello", "  --dry-run ", "--ENCRYPT-KEY AB12345  "]
	end

	describe "#clean" do
		it "should remove leading and trailing whitespace" do
			cln.clean(@opts)[1].should eql("--dry-run")
		end

		it "should downcase the option but not the arguement if it has one" do
			cln.clean(@opts)[2].should eql("--encrypt-key AB12345")
		end

	end


end
