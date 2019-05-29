class CreateSpreeSalesmen < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_salesmen do |t|
      t.string :name
      t.string :google_client_id
      t.string :google_client_secret
      t.string :google_calander_id

      t.timestamps
    end
  end
end
