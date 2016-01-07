require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
    assert_select "h1", "Restau"
    assert_select "button", "Start Your Order"
   
  end

  test "should get day_picker" do
    get :day_picker
    assert_response :success
  end

  test "should create booking_enquiry" do
    get :booking_enquiry
    assert_response :success
    assert_select "h3", "When do you want your table?"
    end
end
