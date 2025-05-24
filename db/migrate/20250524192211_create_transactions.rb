class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 11, scale: 2
      
      t.references :source_account, foreign_key: { to_table: :accounts }
      t.references :target_account, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
