class AddUserIdToWigs < ActiveRecord::Migration[7.2]
  def change
    add_reference :wigs, :user, null: false, foreign_key: true
  end
end
