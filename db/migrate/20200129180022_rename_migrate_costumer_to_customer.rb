class RenameMigrateCostumerToCustomer < ActiveRecord::Migration[6.0]
  def change
    rename_table :costumers, :customers
  end
end
