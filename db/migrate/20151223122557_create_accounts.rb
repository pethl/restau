class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.string :primary_contact
      t.string :email
      t.string :phone

      t.timestamps null: false
    end
  end
end
