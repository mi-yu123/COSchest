class CreatePackingLists < ActiveRecord::Migration[7.2]
  def change
    create_table :packing_lists do |t|
      t.string :item
      t.references :user, null: false, foreign_key: true
      t.references :itemable, polymorphic: true
      t.boolean :packed, default: false

      t.timestamps
    end
  end
end
