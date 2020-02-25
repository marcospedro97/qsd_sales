class AddFieldToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :cancellation_reason, :string
  end
end
