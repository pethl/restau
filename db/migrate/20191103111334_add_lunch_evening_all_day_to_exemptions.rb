class AddLunchEveningAllDayToExemptions < ActiveRecord::Migration
  def change
    add_column :exemptions, :lunch, :boolean
    add_column :exemptions, :dinner, :boolean
  end
end
