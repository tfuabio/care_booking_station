class UsePlanComment < ApplicationRecord
  belongs_to :use_plan
  validates :is_facility, presence: true
  validates :comment, presence: true
end
