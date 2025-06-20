class CorrectTypesUser < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :marital_status, :string
    change_column :users, :legal_entity, :string
  end
end
