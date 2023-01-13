class UsePlan < ApplicationRecord
  belongs_to :user
  belongs_to :care_manager
  belongs_to :facility, optional: true  # 計画作成時
  has_many :use_plan_comments, dependent: :destroy
  has_many :booking_contacts, dependent: :destroy
  validates :start_date, presence: true
  validates :end_date, presence: true

  enum status: {
    planning: 0,
    contacting: 1,
    confirmed: 2,
    canceled: 3
  }

  # 入力された日付が正しいか判定するためのメソッド
  def correct_date?
    if self.start_date.before?(Date.today) || self.start_date.after?(self.end_date) || self.start_date == self.end_date
      # 入所日が今日より前のとき
      # 入所日が退所日より後のとき
      # 入所日と退所日が同一のとき
      false
    else
      true
    end
  end
end