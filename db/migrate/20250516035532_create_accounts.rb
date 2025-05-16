class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :account do |t|
      t.float :balance
      t.string :cvu
      t.string :alias

      t.timestamps
    end
  end
end
