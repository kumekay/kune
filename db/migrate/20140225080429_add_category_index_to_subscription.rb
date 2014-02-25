class AddCategoryIndexToSubscription < ActiveRecord::Migration
  def change
    add_index :subscriptions, :category_id
  end
end
