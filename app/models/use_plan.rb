class UsePlan < ApplicationRecord
  belongs_to :user
  belongs_to :care_manager
  belongs_to :facility
  validates :start_date, presence: true
  validates :end_date, presence: true
end
