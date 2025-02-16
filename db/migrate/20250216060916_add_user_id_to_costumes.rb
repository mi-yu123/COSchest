class AddUserIdToCostumes < ActiveRecord::Migration[7.2]
  def change
    add_reference :costumes, :user, null: false, foreign_key: true
  end
end
