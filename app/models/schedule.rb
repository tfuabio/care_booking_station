class Schedule < ApplicationRecord
  belongs_to :facility
  validates :date, presence: true
end
