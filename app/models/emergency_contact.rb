class EmergencyContact < ApplicationRecord
  belongs_to :user
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :phone_number, presence: true
  validates :relationship, presence: true
  validates :status, presence: true
  has_one_attached :image
end
