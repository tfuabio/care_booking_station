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
      # 利用計画のステータスがキャンセルの場合は除く
      return true unless use_plan.start_date.after?(to) || use_plan.end_date.before?(from) || use_plan.status == "canceled"
    end
    false
  end

  # 利用計画の内容に応じて施設スケジュールを更新するメソッド
  # 引数に更新したい利用詳細ステータスを指定して使う
  def save_schdule(status)
    from = self.start_date
    to = self.end_date

    # キャンセル時の処理
    if status == "canceled"
      # 該当の利用詳細データが存在するか確認
      (from..to).each do |date|
        # 施設のスケジュールから日付が一致するレコードを取得
        schedule = self.facility.schedules.find_by(date: date)
        # 利用詳細からユーザーIDが一致するものを取得
        use_detail = schedule.use_details.find_by(user_id: self.user_id)
        # レコードが見つからない場合falseを返す
        return false if schedule == nil || use_detail == nil
      end
      # 該当の利用詳細データをすべてキャンセルに更新
      # 更新成功するとtrueを返す
      (from..to).each do |date|
        # 施設のスケジュールから日付が一致するレコードを取得
        schedule = self.facility.schedules.find_by(date: date)
        # 利用詳細からユーザーIDが一致するものを取得
        use_detail = schedule.use_details.find_by(user_id: self.user_id)
        use_detail.update(status: "canceled")
      end

    # 予約確定時の処理
    elsif status == "confirmed"
      # 該当の利用詳細データが存在しないまたはキャンセルになっているか確認
      (from..to).each do |date|
        # 施設のスケジュールから日付が一致するレコードを取得
        schedule = self.facility.schedules.find_by(date: date)
        unless schedule == nil
          # 日付のレコードが取得できた場合に利用詳細のステータスを確認
          use_detail = schedule.use_details.find_by(user_id: self.user_id)
          unless use_detail == nil
            # 利用詳細が取得できた場合に利用詳細ステータスがキャンセルでない場合にfalseを返す
            return false if use_detail.status == "canceled"
          end
        end
      end

      # 施設スケジュールに利用計画の日程を反映
      (from..to).each do |date|
        # 利用詳細に格納するステータスを決定
        if date == from
          status = "in"  # 入所日
        elsif date == to
          status = "out"  # 退所日
        else
          status = "all_day"  # 終日利用
        end
        # 施設のスケジュールから日付が一致するレコードを取得（なければ作成）
        schedule = self.facility.schedules.find_or_create_by(date: date)
        # 利用者の利用詳細を取得
        use_detail = schedule.use_details.find_by(user_id: self.user_id)
        if use_detail == nil
          # 取得できない場合、レコードを作成して保存
          use_detail = schedule.use_details.new(user_id: self.user_id, status: status)
          use_detail.save
        else
          # 取得できた場合はステータス更新する
          use_detail.update(status: status)
        end
      end
    else
      # キャンセルまたは予約確定以外はfalse
      return false
    end
  end
end