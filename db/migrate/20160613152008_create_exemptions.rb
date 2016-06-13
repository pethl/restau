class CreateExemptions < ActiveRecord::Migration
  def change
    create_table :exemptions do |t|
      t.date :exempt_day
      t.string :exempt_message

      t.timestamps null: false
    end
  end
end
