require 'test_helper'

class RdetailsControllerTest < ActionController::TestCase
  setup do
    @rdetail = rdetails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rdetails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rdetail" do
    assert_difference('Rdetail.count') do
      post :create, rdetail: { booking_duration: @rdetail.booking_duration, last_booking_time: @rdetail.last_booking_time, max_booking: @rdetail.max_booking, min_booking: @rdetail.min_booking, restaurant_id: @rdetail.restaurant_id }
    end

    assert_redirected_to rdetail_path(assigns(:rdetail))
  end

  test "should show rdetail" do
    get :show, id: @rdetail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rdetail
    assert_response :success
  end

  test "should update rdetail" do
    patch :update, id: @rdetail, rdetail: { booking_duration: @rdetail.booking_duration, last_booking_time: @rdetail.last_booking_time, max_booking: @rdetail.max_booking, min_booking: @rdetail.min_booking, restaurant_id: @rdetail.restaurant_id }
    assert_redirected_to rdetail_path(assigns(:rdetail))
  end

  test "should destroy rdetail" do
    assert_difference('Rdetail.count', -1) do
      delete :destroy, id: @rdetail
    end

    assert_redirected_to rdetails_path
  end
end
