class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :number, null: false
      t.date :issue_date
      t.date :expiry_date
      t.integer :payment_system, null: false # enum: {visa: 0, mastercard: 1}
      t.string :cvv
      t.integer :card_type, null: false      # enum: {credit: 0, debit: 1}     
      
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
