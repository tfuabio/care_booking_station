class UseDetail < ApplicationRecord
  belongs_to :schedule
  belongs_to :user
  validates :status, presence: true
end
