class ChangeTypeColumnProductOfOrder < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :product_id, :integer
  end
end
