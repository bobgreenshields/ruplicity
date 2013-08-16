require_relative '../../lib/ruplicity/set_errors.rb'

include Ruplicity

class SetErrorsTest
	include SetErrors
end

describe SetErrorsTest do

	context "when new" do
		let(:errors_test) { SetErrorsTest.new }
			describe "#has_errors?" do
				specify { errors_test.has_errors?.should be_false }
			end

			describe "#has_no_errors?" do
				specify { errors_test.has_no_errors?.should be_true }
			end

			describe "#errors" do
				it "should be empty" do
					errors_test.errors.length.should eql(0)
				end
			end
	end

	context "with default error poster" do
		context "when an error is posted" do
			subject(:errors_test) { SetErrorsTest.new.tap {|e| e.post_error("New error")} }

			describe "#has_errors?" do
				specify { errors_test.has_errors?.should be_true }
			end

			describe "#has_no_errors?" do
				specify { errors_test.has_no_errors?.should be_false }
			end

			describe "#errors" do
				it "should include the error" do
					errors_test.errors.should include("New error")
				end
			end
		end
	end

	context "with external error handler" do
		let(:error_handler) { SetErrorsTest.new }
		def errors_test
			res = SetErrorsTest.new
			res.error_poster = ->(error){ error_handler.post_error(error) }
			res
		end

		context "when an error is posted" do
			before do
				errors_test.post_error("New error")
			end

			it "should post the error to the handler" do
				error_handler.errors.should include("New error")
			end
		end
	end


end
