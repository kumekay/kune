class AddUserAndApproveIndexToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :user_id, :integer
    add_index :articles, [:approved, :approved_at]
  end
end
