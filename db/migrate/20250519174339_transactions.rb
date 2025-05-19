class Transactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :source_account, foreign_key: { to_table: :accounts }
      t.references :target_account, foreign_key: { to_table: :accounts }
      t.decimal :amount, precision: 11, scale: 2

      t.timestamps
    end
  end
end
