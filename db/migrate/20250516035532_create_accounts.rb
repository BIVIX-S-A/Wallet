class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :account do |t|
      t.float :balance
      t.string :cvu
      t.string :alias
      t.references :users, null :false, foreign_key :true
      t.timestamps
    end
  end
end
