class UseDetail < ApplicationRecord
  belongs_to :schedule
  belongs_to :user
  validates :status, presence: true

  enum status: {
    in: 0,
    all_day:1,
    out:3
  }
end
