require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save account without any fields" do
    account = Account.new
    assert_not account.save
  end

  test "should not save account without company_name" do
    account = Account.create(primary_contact: 'Shauna Guinn', email: 'hangfirebbq@gmail.com', phone:'07803293552')
    assert_not account.save
  end

  test "should not save account without primary_contact" do
    account = Account.create(company_name: 'Hang Fire Smoke House Co', email: 'hangfirebbq@gmail.com', phone:'07803293552')
    assert_not account.save
  end 

  test "should not save account without email" do
    account = Account.create(company_name: 'Hang Fire Smoke House Co', phone:'07803293552')
    assert_not account.save
  end 

  test "should not save account without phone" do
    account = Account.create(company_name: 'Hang Fire Smoke House Co', email: 'hangfirebbq@gmail.com')
    assert_not account.save
  end 
  
end


