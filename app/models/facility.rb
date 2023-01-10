class Facility < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :contracts, dependent: :destroy
  has_many :booking_contacts, dependent: :destroy
  has_many :use_plans, dependent: :destroy
  has_many :schedules, dependent: :destroy
  validates :name, presence: true
  validates :kana_name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :phone_number, presence: true
  has_one_attached :image
end
