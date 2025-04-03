class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :handle_name
      t.string :image
      t.integer :activity, default: 0
      t.string :location
      t.string :genre
      t.text :message

      t.timestamps
    end
  end
end
