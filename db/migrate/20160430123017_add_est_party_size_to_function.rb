class AddEstPartySizeToFunction < ActiveRecord::Migration
  def change
     add_column :functions, :est_party_size, :string
  end
end
