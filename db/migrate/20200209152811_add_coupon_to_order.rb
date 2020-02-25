class AddCouponToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :coupon_name, :string
  end
end
