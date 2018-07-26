class AddWhenToFunctions < ActiveRecord::Migration
  def change
    add_column :functions, :when_is_event, :string
  end
end
