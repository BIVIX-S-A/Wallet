class CreateMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :movements do |t|
      t.integer :movement_id
      t.decimal :amount, precision: 11, scale: 2
      t.date :movement_date

      t.timestamps
    end
  end
end