class CreateStaffevents < ActiveRecord::Migration
  def change
    create_table :staffevents do |t|
      t.integer :staff_id
      t.datetime :event_date
      t.string :event_reason
      t.text :event_notes

      t.timestamps null: false
    end
  end
end
