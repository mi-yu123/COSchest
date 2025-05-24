class CreateMyPhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :my_photos do |t|
      t.string :image
      t.string :title
      t.text :memo
      t.datetime :posted_at

      t.timestamps
    end
  end
end
