class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :category_id, null: false
      t.string :security_key, null: false

      t.timestamps
    end

    add_index :subscriptions, :security_key, unique: true
    add_index :subscriptions, [:user_id, :category_id], unique: true
  end
end
