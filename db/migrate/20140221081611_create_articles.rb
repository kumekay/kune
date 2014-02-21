class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :summary
      t.text :body

      t.timestamps
    end
  end
end
