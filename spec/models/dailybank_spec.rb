require 'rails_helper'

# :user_id, :effective_date, :banking, :card_payments, :expenses, :actual_cash_total, :till_takings, :wet_takings, :dry_takings, :merch_takings, :vouchers_sold, :vouchers_used, :deposit_sold, :deposit_used, :actual_till_takings, :calculated_variance, :user_variance, :variance_comment, :status, :variance_gap, 

RSpec.describe Dailybank, :type => :model do
 
  it "is valid with essential user inputs" do
      dailybank = Dailybank.new(
        effective_date: '2016-06-01',
        status: 'Created',
        banking: 100,
        card_payments: 50,
        expenses: 10,
        till_takings: 100,
        vouchers_sold: 50,
        vouchers_used: 10,
        deposit_sold: 10,
        deposit_used: 10,
        user_variance: 1)
        
  expect(dailybank).to be_valid end
  
  it "is invalid without an effective_date" do
        dailybank = Dailybank.new(
          effective_date: nil,
          status: 'Created',
          banking: 100,
          card_payments: 50,
          expenses: 10,
          till_takings: 100,
          vouchers_sold: 50,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:effective_date]).to include("can't be blank")
  end
  
  it "is invalid without status" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: nil,
          banking: 100,
          card_payments: 50,
          expenses: 10,
          till_takings: 100,
          vouchers_sold: 50,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:status]).to include("can't be blank")
  end
  
  it "is invalid without banking" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: nil,
          card_payments: 50,
          expenses: 10,
          till_takings: 100,
          vouchers_sold: 50,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:banking]).to include("cannot be blank")
  end
  
  it "is invalid without card_payments" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: nil,
          expenses: 10,
          till_takings: 100,
          vouchers_sold: 50,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:card_payments]).to include("cannot be blank")
  end
  
  it "is invalid without expenses" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: nil,
          till_takings: 100,
          vouchers_sold: 50,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:expenses]).to include("cannot be blank")
  end
  
  it "is invalid without till_takings" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: 20,
          till_takings: nil,
          vouchers_sold: 50,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:till_takings]).to include("cannot be blank")
  end
  
  it "is invalid without vouchers_sold" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: 20,
          till_takings: 100,
          vouchers_sold: nil,
          vouchers_used: 10,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:vouchers_sold]).to include("cannot be blank, enter zero if none sold")
  end
  
  it "is invalid without vouchers_used" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: 20,
          till_takings: 100,
          vouchers_sold: 10,
          vouchers_used: nil,
          deposit_sold: 10,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:vouchers_used]).to include("cannot be blank, enter zero if none used")
  end
  
  it "is invalid without deposit_sold:" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: 20,
          till_takings: 100,
          vouchers_sold: 10,
          vouchers_used: 20,
          deposit_sold: nil,
          deposit_used: 10,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:deposit_sold]).to include("cannot be blank, enter zero if none sold")
  end
  
  it "is invalid without deposit_used:" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: 20,
          till_takings: 100,
          vouchers_sold: 10,
          vouchers_used: 20,
          deposit_sold: 30,
          deposit_used: nil,
          user_variance: 1)
    
    dailybank.valid?
    expect(dailybank.errors[:deposit_used]).to include("cannot be blank, enter zero if none used")
  end
  
  it "is invalid without user_variance::" do
        dailybank = Dailybank.new(
          effective_date: '2016-06-01',
          status: 'Created',
          banking: 100,
          card_payments: 30,
          expenses: 20,
          till_takings: 100,
          vouchers_sold: 10,
          vouchers_used: 20,
          deposit_sold: 30,
          deposit_used: 20,
          user_variance: nil)
    
    dailybank.valid?
    expect(dailybank.errors[:user_variance]).to include("cannot be blank, enter variance value which may be zero")
  end
  
  it "redirects to show with essential user inputs and zero variance" do
      dailybank = Dailybank.new(
        effective_date: '2016-06-01',
        status: 'Created',
        banking: 100,
        card_payments: 50,
        expenses: 10,
        till_takings: 100,
        vouchers_sold: 50,
        vouchers_used: 0,
        deposit_sold: 10,
        deposit_used: 0,
        user_variance: 0)
      dailybank.create  
        
  expect(response).to redirect_to dailybank end
end
