class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :owner_account, null: false, foreign_key: { to_table: :accounts }
      t.references :contact_account, null: false, foreign_key: { to_table: :accounts }
      t.string :custom_name #Optional

      t.timestamps
    end
    add_index :contacts, [:owner_account_id, :contact_account_id], unique: true, name: 'index_contacts_owner_and_contact'
  end
end
