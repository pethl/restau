class CreateDailystats < ActiveRecord::Migration
  def change
    create_table :dailystats do |t|
      t.date :action_date
      t.integer :cancelled_bookings
      t.integer :confirmed_bookings
      t.integer :diners_fed
      t.float :avg_headcount_per_booking
      t.float :avg_days_prior_to_booking
      t.float :avg_days_prior_to_booking_under_seven
      t.float :avg_days_prior_to_booking_over_six
      t.integer :dawn
      t.integer :early
      t.integer :lunch
      t.integer :afternoon
      t.integer :hometime
      t.integer :evening

      t.timestamps null: false
    end
  end
end
