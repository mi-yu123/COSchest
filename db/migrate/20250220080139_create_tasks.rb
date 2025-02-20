class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :description
      t.datetime :due_date
      t.boolean :completed, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
