class BookingContact < ApplicationRecord
  belongs_to :use_plan
  belongs_to :facility

  enum status: {
    awaiting_reply: 0,
    bookable: 1,
    not_bookable: 2,
    closing: 3
  }

  # 問い合わせ済みの施設かチェックする
  def contacted?
    if self.use_plan.booking_contacts.exists?(facility_id: self.facility_id)
      true
    else
      false
    end
  end

  # 新規利用者の問い合わせかチェックする
  def new_user?
    user = self.use_plan.user
    facility = self.facility
    if facility.contracts.exists?(user_id: user.id)
      false
    else
      true
    end
  end

  # 返答後の利用計画状態確認用
  def reply_status
    use_plan = self.use_plan
    status = use_plan.status
    if status == "contacting"
      "予約確定待ち"
    elsif status == "confirmed"
      if use_plan.facility_id == current_facility.id
        "予約を承りました"
      else
        "他施設に予約確定"
      end
    end
  end

  # 満床かどうかを判定するメソッド
  def no_beds?
    use_plan = self.use_plan
    from = use_plan.start_date
    to = use_plan.end_date

    # 問い合わせ先の施設スケジュールを利用期間内のみ取得
    schedules = self.facility.schedules.select { |schedule| schedule.date.after?(from) && schedule.date.defore?(to) }

    # 定員に達している日程があればtrue、なければfalse
    schedules.each do |schedule|
      return true if schedule.use_details.count == use_plan.facility.capacity
    end
    return false
  end
end
