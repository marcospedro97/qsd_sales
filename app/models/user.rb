class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { seller: 0, admin: 5 }
  has_many :customers, dependent: :restrict_with_exception

  def nickname
    email.split('@').first
  end
end
