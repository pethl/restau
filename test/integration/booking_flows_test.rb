require 'test_helper'

class BookingFlowsTest < ActionDispatch::IntegrationTest
   test "open booking_enquiry page" do
     # open booking_enquiry page
       
         get "/booking_enquiry"
         assert_response :success
   end
end
