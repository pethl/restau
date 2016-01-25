class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :ref
      t.string :msg
      t.text :desc

      t.timestamps null: false
    end
  end
end
