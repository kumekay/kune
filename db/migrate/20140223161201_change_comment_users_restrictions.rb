class ChangeCommentUsersRestrictions < ActiveRecord::Migration
  def change
    change_column_default :comments, :user_id, nil
    change_column :comments, :user_id, :integer, :null => true
  end
end
