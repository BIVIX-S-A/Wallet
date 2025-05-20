class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.decimal :balance, precision: 11, scale: 2, default: "0.0", null: false
      t.string :cvu, unique: true
      t.string :alias, unique: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
