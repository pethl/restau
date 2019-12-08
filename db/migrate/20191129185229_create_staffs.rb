class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :status
      t.string :job_title
      t.string :payment_terms

      t.timestamps null: false
    end
  end
end
