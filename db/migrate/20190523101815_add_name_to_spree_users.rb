class AddNameToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :name, :string
    add_column :spree_users, :phone, :integer
  end
end
