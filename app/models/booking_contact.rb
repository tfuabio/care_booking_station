class BookingContact < ApplicationRecord
  belongs_to :user_plan
  belongs_to :facility
end
