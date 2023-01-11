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
  validates :gender, presence: true
  validates :birthday, presence: true
  validates :life_history, length: { maximum: 500 }
  validates :medical_history, length: { maximum: 500 }
  has_one_attached :image

  enum current_status: {
    home_care: 0,
    redident_care: 1,
    hospitalization: 2,
    passed_away: 3
  }

  enum care_level_status: {
    pending: 0,
    changing: 1,
    requiring_help_1: 2,
    requiring_help_2: 3,
    long_term_care_level_1: 4,
    long_term_care_level_2: 5,
    long_term_care_level_3: 6,
    long_term_care_level_4: 7,
    long_term_care_level_5: 8
  }

  enum gender: {
    male: 0,
    female:1
  }
end
