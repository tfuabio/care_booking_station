class BookingContact < ApplicationRecord
  belongs_to :use_plan
  belongs_to :facility

  enum status: {
    awaiting_reply: 0,
    bookable: 1,
    not_bookable: 2
  }

  # 問い合わせ済みの施設かチェックする
  def contacted?
    if self.use_plan.booking_contacts.exists?(facility_id: self.facility_id)
      true
    else
      false
    end
  end
end
