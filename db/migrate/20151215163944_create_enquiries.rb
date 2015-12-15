class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.date :col_day
      t.time :col_time

      t.timestamps null: false
    end
  end
end
