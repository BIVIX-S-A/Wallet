class Transactions < ActiveRecord::Migration[8.0]
  def change

    create_table :transactions do |t|
      t.references :source_account, foreign_key: true
      t.references :target_account, foreign_key: true
      t.float :amount

      t.timestamps
  end
end
