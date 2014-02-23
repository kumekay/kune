class AddReviewedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :fresh, :boolean, default: true
  end
end
