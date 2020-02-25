class AddColumnPlanAndPriceToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :plan, :integer
    add_column :orders, :price, :integer
  end
end
