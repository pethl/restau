class AddConfirmationEmailDinersToRdetails < ActiveRecord::Migration
  def change
    add_column :rdetails, :confirmation_email_diners_max, :integer
  end
end
