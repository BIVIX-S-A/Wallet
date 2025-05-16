class CreateMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :movements do |t|
      t.integer :movement_id
      t.float :amount
      t.date :movement_date

      t.timestamps
    end
  end
end
