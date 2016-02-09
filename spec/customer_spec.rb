require 'rails_helper'

describe Customer do
  
it "is valid with an email address" do
    customer = Customer.new(
      email: 'jackholmes@gmail.com')
      expect(customer).to be_valid
    end

it "is valid without a name" do
    customer = Customer.new(
      email: 'jackholmes@gmail.com',
      name: nil)
      expect(customer).to be_valid
    end
    
it "is valid without a phone" do
    customer = Customer.new(
      email: 'jackholmes@gmail.com',
      name: nil,
      phone: nil)
      expect(customer).to be_valid
    end

it "is valid without a desc" do
    customer = Customer.new(
      email: 'jackholmes@gmail.com',
      name: nil,
      phone: nil,
      desc: nil)
      expect(customer).to be_valid
    end   
    
it "is valid subscribed = null" do
    customer = Customer.new(
      email: 'jackholmes@gmail.com',
      subscribed: nil)
      expect(customer).to be_valid
    end
    
it "is valid subscribed = true" do
    customer = Customer.new(
      email: 'jackholmes@gmail.com',
      subscribed: true)
      expect(customer).to be_valid
    end
    
it "is valid subscribed = false"  do
    customer = Customer.new(
      email: 'jackholmes@gmail.com',
      subscribed: false)
      expect(customer).to be_valid
    end


it "is invalid with a duplicate email address" do
  Customer.create(
      email: 'jackholmes@gmail.com')
    
    customer = Customer.new(
      email: 'jackholmes@gmail.com')
      
      customer.valid?
      expect(customer.errors[:email]).to include("has already been taken")
    end
    
it "returns search for email containing part of email" do
  math = Customer.create(email: 'mathrees@gmail.com', name: 'math', phone: '0788908')
  kath = Customer.create(email: 'kathmorg@gmail.com', name: 'kath', phone: '0771340')
  lisa = Customer.create(email: 'lisapeth@gmail.com', name: 'lisa', phone: '07803293')
  search = {}
  search[:email] = 'math'
  expect(Customer.search(search)).to eq [math]
  end
  
it "returns search for name containing part of name" do
  math = Customer.create(email: 'mathrees@gmail.com', name: 'math', phone: '0788908')
  kath = Customer.create(email: 'kathmorg@gmail.com', name: 'kath', phone: '0771340')
  lisa = Customer.create(email: 'lisapeth@gmail.com', name: 'lisa', phone: '07803293')
  search = {}
  search[:name] = 'kath'
  expect(Customer.search(search)).to eq [kath]
  end  

it "returns search for phone containing part of phone" do
  math = Customer.create(email: 'mathrees@gmail.com', name: 'math', phone: '0788908')
  kath = Customer.create(email: 'kathmorg@gmail.com', name: 'kath', phone: '0771340')
  lisa = Customer.create(email: 'lisapeth@gmail.com', name: 'lisa', phone: '07803293')
  search = {}
  search[:phone] = '07803'
  expect(Customer.search(search)).to eq [lisa]
  end    

it "returns search for email containing part of email - multiple match" do
  math = Customer.create(email: 'mathrees@gmail.com', name: 'math', phone: '0788908')
  kath = Customer.create(email: 'kathmorg@gmail.com', name: 'kath', phone: '0771340')
  lisa = Customer.create(email: 'lisapeth@gmail.com', name: 'lisa', phone: '07803293')
  search = {}
  search[:email] = 'gmail'
  expect(Customer.search(search)).to eq [math, kath, lisa]
  end  

it "returns search for no records for email match failure" do
  math = Customer.create(email: 'mathrees@gmail.com', name: 'math', phone: '0788908')
  kath = Customer.create(email: 'kathmorg@gmail.com', name: 'kath', phone: '0771340')
  lisa = Customer.create(email: 'lisapeth@gmail.com', name: 'lisa', phone: '07803293')
  search = {}
  search[:email] = 'hotmail'
  expect(Customer.search(search)).not_to include [math]
  end      

end