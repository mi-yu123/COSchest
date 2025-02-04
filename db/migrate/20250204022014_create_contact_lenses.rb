class CreateContactLenses < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_lenses do |t|
      t.string :name
      t.string :image
      t.date :expiration_date
      t.integer :quantity
      t.text :memo

      t.timestamps
    end
  end
end
