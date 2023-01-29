class Schedule < ApplicationRecord
  belongs_to :facility
  has_many :use_details, dependent: :destroy
  validates :date, presence: true
end
