class DailyChecksController < ApplicationController
  before_action :logged_in_user, only: [:today, :yesterday, :history]
  
  def today
    @cashfloats = Cashfloat.where("created_at > ? AND created_at < ?", Date.today.beginning_of_day, Date.today.end_of_day)
    @safe_morning = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.today.beginning_of_day, Date.today.end_of_day, "Safe", "Morning")
    @safe_evening = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.today.beginning_of_day, Date.today.end_of_day, "Safe", "Evening")
    @main_till_morning = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.today.beginning_of_day, Date.today.end_of_day, "Main Till", "Morning")
    @main_till_evening = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.today.beginning_of_day, Date.today.end_of_day, "Main Till", "Evening")
  end

  def yesterday
    @cashfloats = Cashfloat.where("created_at > ? AND created_at < ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day)
    @safe_morning = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day, "Safe", "Morning")
    @safe_evening = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day, "Safe", "Evening")
    @main_till_morning = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day, "Main Till", "Morning")
    @main_till_evening = Cashfloat.where("created_at > ? AND created_at < ? AND float_type = ? AND  period = ?", Date.yesterday.beginning_of_day, Date.yesterday.end_of_day, "Main Till", "Evening")
  end

  def history
    @cashfloats = Cashfloat.all
    @cashfloats_by_date = @cashfloats.group_by {|i| i.created_at.to_date}
  end
  
end
