class RenameColumnCostumerIdToCustomerIdInOrdersTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :costumer_id, :customer_id
  end
end
