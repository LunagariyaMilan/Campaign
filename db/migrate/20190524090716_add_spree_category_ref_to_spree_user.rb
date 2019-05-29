class AddSpreeCategoryRefToSpreeUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_users, :category, foreign_key: true
    add_reference :spree_users, :salesman, foreign_key: true
  end
end
