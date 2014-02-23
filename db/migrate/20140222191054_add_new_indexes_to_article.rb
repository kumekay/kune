class AddNewIndexesToArticle < ActiveRecord::Migration
  def change
    remove_index :articles, [:approved, :approved_at]
    add_index :articles, :fresh
    add_index :articles, [:fresh, :approved]
  end
end
