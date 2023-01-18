class Facility::SchedulesController < ApplicationController
  def index
    # 今日の日付を取得
    @today = Date.today

    # 今月のスケジュールをすべて取得
    schedules = current_facility.schedules.select { |schedule| schedule.date.month == @today.month }

    # 予約表用に今月の日付を取得
    @days = @today.all_month

    @week = ["日", "月", "火", "水", "木", "金", "土"]

    # 2次元ハッシュに利用詳細を格納
    @hash = Hash.new { |h,k| h[k] = {} }
    schedules.each do |schedule|
      date = schedule.date
      use_details = schedule.use_details
      use_details.each do |use_detail|
        @hash[use_detail.user][date] = use_detail.status_i18n
      end
    end
  end

  def show
    @schedule = Schedules.find(params[:id])
  end
end
