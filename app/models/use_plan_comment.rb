class UsePlanComment < ApplicationRecord
  belongs_to :use_plan
  validates :comment, presence: true
  validates :speaker_id, presence: true
end
