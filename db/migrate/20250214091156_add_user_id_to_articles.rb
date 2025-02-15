class AddUserIdToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :user_id, :integer
  end
end
