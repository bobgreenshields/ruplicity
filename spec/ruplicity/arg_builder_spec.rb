require 'spec_helper'
require_relative '../../lib/ruplicity/arg_builder'

describe ArgBuilder do
	describe "#normalise_keys" do
		let (:argb) { ArgBuilder.new }
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

		it "should not chnage any of the values" do
			argb.normalise_keys(@args)[:name].should eql("base")
			argb.normalise_keys(@args)[:force].should eql(nil)
			argb.normalise_keys(@args)[:dry_run].should eql(nil)
		end

	end




end
