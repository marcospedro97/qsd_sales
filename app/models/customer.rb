class Customer < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :document, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :birth_date, presence: true
  has_many :orders, dependent: :restrict_with_exception
  belongs_to :user

  def identification
    "#{name} - #{document}"
  end
end
