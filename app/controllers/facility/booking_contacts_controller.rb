class Facility::BookingContactsController < ApplicationController
  before_action :authenticate_facility!
  before_action :ensure_correct_facility, only: [:show, :reply]

  def index
    @status = params[:status]
    @status = 'all' if @status.nil?
    if @status == 'all'
      @booking_contacts = current_facility.booking_contacts.sort_by{ |x| x.created_at }.reverse
    else
      @booking_contacts = current_facility.booking_contacts.where(status: @status).sort_by{ |x| x.created_at }.reverse
    end
  end

  def show
    # 入所日と退所日を取得
    from = @booking_contact.use_plan.start_date
    to = @booking_contact.use_plan.end_date

    # 期間中のスケジュールをすべて取得
    schedules = current_facility.schedules.select { |x| x.date.before?(to + 1) && x.date.after?(from - 1) }

    # 予約表用に今月の日付を取得
    @days = (from..to)

    @week = ["日", "月", "火", "水", "木", "金", "土"]

    # 2次元ハッシュに利用期間中の予約状況を格納
    @hash = Hash.new { |h,k| h[k] = {} }
    schedules.each do |schedule|
      date = schedule.date
      use_details = schedule.use_details
      use_details.each do |use_detail|
        @hash[use_detail.user][date] = use_detail.status_i18n
      end
    end

    @use_plan = @booking_contact.use_plan
    @user = @use_plan.user
    @use_plan_comment = UsePlanComment.new
    @use_plan_comments = @use_plan.use_plan_comments
  end

  def reply
    content = params[:content]  # bookable or not_bookable

    # 空き状況の確認
    if @booking_contact.no_beds?
      redirect_to facility_booking_contact_path(@booking_contact), alert: "満床のため返答の送信を中止しました。"
    else
      if @booking_contact.update(status: content)
        if content == "bookable"
          flash[:notice] = "予約可能で返答しました。"
        else
          flash[:notice] = "予約不可で返答しました。"
        end
      else
        flash[:alert] = "返答の送信に失敗しました。"
      end
      redirect_to facility_booking_contact_path(@booking_contact)
    end
  end

  private

  def ensure_correct_facility
    @booking_contact = BookingContact.find(params[:id])
    unless @booking_contact.facility_id == current_facility.id
      redirect_to facility_booking_contacts_path, alert: '他施設への問い合わせは閲覧できません。'
    end
  end
end