class Order < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  validates :product_id, :price_id, :plan_id, presence: true
  validates :cancellation_reason, presence: true, if: :cancelled?

  enum status: { open: 0, approved: 4, cancelled: 8 }
end
