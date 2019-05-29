class AddFollowFieldToSpreeUser < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :follow_datetime, :datetime
  end
end
