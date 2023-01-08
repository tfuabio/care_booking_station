class UsePlan < ApplicationRecord
  belongs_to :user
  belongs_to :care_manager
  belongs_to :facility
  has_many :use_plan_comments, dependent: :destroy
  validates :start_date, presence: true
  validates :end_date, presence: true
end
