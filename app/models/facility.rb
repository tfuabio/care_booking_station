class Facility < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :kana_name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :phone_number, presence: true
  validates :is_deleted, presence: true
  has_one_attached :image
end
