class RenameColumnsPriceProductPlanOfOrder < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :product, :product_id
    rename_column :orders, :price, :price_id
    rename_column :orders, :plan, :plan_id
  end
end
