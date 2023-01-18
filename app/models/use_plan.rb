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
    from = self.start_date
    to = self.end_date
    if from.before?(Date.today) || from.after?(to) || from == to
      # 入所日が今日より前のとき
      # 入所日が退所日より後のとき
      # 入所日と退所日が同一のとき
      false
    else
     true
    end
  end

  # 入力された日付が同利用者の利用計画と重複していないか判定するためのメソッド
  def duplicate?
    from = self.start_date  # 入所日
    to = self.end_date  # 退所日
    # すでに登録されている利用計画を取得
    use_plans = self.care_manager.use_plans.where(user_id: self.user_id)
    use_plans.each do |use_plan|
      # 「退所日より後の期間である場合」または「入所日より前の期間である場合」以外は「重複」とみなす
      return true unless use_plan.start_date.after?(to) || use_plan.end_date.before?(from)
    end
    false
  end
end