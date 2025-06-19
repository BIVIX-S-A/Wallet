class AddAssociationsToMovements < ActiveRecord::Migration[8.0]
  def change
    add_reference :movements, :account, null: false, foreign_key: true
    add_reference :movements, :transaction, null: false, foreign_key: true

    remove_column :movements, :movement_id, :integer

  end
end
