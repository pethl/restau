class AddVarCommentToDailybanks < ActiveRecord::Migration
  def change
    add_column :dailybanks, :variance_comment, :string
  end
end
