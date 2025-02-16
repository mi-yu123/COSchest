class AddUserIdToContactLenses < ActiveRecord::Migration[7.2]
  def change
    add_reference :contact_lenses, :user, null: false, foreign_key: true
  end
end
