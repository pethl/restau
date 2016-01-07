require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should not save restaurant without any fields" do
    restaurant = Restaurant.new
    assert_not restaurant.save
  end

  test "should not save restaurant without name" do
    restaurant = Restaurant.create(location: 'Pump House, Barry', website: 'hangfirebbq.com', primary_contact: 'Sam Evans', email: 'hangfirebbq@gmail.com', phone:'07803293552')
    assert_not restaurant.save
  end
  
  test "should not save restaurant without location" do
    restaurant = Restaurant.create(name: 'Hang Fire Southern Kitchen', website: 'hangfirebbq.com', primary_contact: 'Sam Evans', email: 'hangfirebbq@gmail.com', phone:'07803293552')
    assert_not restaurant.save
  end
  
  test "should not save restaurant without primary_contact" do
    restaurant = Restaurant.create(name: 'Hang Fire Southern Kitchen', location: 'Pump House, Barry', website: 'hangfirebbq.com', email: 'hangfirebbq@gmail.com', phone:'07803293552')
    assert_not restaurant.save
  end
  
  test "should not save restaurant without website" do
    restaurant = Restaurant.create(name: 'Hang Fire Southern Kitchen', location: 'Pump House, Barry', primary_contact: 'Sam Evans', email: 'hangfirebbq@gmail.com', phone:'07803293552')
    assert_not restaurant.save
  end
 
  test "should not save restaurant without email" do
    restaurant = Restaurant.create(name: 'Hang Fire Southern Kitchen', location: 'Pump House, Barry', primary_contact: 'Sam Evans', website: 'hangfirebbq.com', phone:'07803293552')
    assert_not restaurant.save
  end
  
  test "should not save restaurant without phone" do
    restaurant = Restaurant.create(name: 'Hang Fire Southern Kitchen', location: 'Pump House, Barry', primary_contact: 'Sam Evans', website: 'hangfirebbq.com', email: 'hangfirebbq@gmail.com')
    assert_not restaurant.save
  end
  
  
end
