class CreateCostumes < ActiveRecord::Migration[7.2]
  def change
    create_table :costumes do |t|
      t.string :character_name
      t.integer :status, default: 0
      t.string :image
      t.text :memo

      t.timestamps
    end
  end
end
