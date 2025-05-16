class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.integer :dni
      t.date :birth_date
      t.string :phone
      t.string :address
      t.string :email
      t.integer :marital_status #Define marital status on the model! 
      t.boolean :legal_entity

      t.timestamps
    end
  end
end
