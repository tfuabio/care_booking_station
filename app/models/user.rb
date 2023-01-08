class User < ApplicationRecord
  belongs_to :care_manager
  has_many :emergency_contacts, dependent: :destroy
  has_many :use_details, dependent: :destroy
  has_many :use_plans, dependent: :destroy
  has_many :contracts, dependent: :destroy
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :phone_number, presence: true
  validates :current_status, presence: true
  validates :care_level_status, presence: true
  validates :sex, presence: true
  validates :age, presence: true
  has_one_attached :image
end
