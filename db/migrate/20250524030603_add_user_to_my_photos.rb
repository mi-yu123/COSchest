class AddUserToMyPhotos < ActiveRecord::Migration[7.2]
  def change
    add_reference :my_photos, :user, null: false, foreign_key: true
  end
end
