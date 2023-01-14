class CareManager::BookingContactsController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:create, :determine]

  def create
    booking_contact = @use_plan.booking_contacts.new(booking_contact_params)
    if booking_contact.contacted?
      flash.now[:alert] = "#{booking_contact.facility.name}への問い合わせはすでに送信済みのため送信を中止しました。"
    else
      if booking_contact.save
        flash.now[:notice] = "#{booking_contact.facility.name}へ問い合わせを送信しました。"
        @use_plan.update(status: "contacting")
      else
        flash.now[:alert] = "問い合わせに失敗しました。"
      end
    end
    @booking_contact = BookingContact.new
    @facilities = Facility.all
    @booking_contacts = @use_plan.booking_contacts
    render 'care_manager/use_plans/show'
  end

  def determine
    @booking_contact = BookingContact.find(params[:booking_contact_id])

    # 予約可能か確認する
    from = @use_plan.start_date
    to = @use_plan.end_date
    schedules = @booking_contact.facility.schedules.select { |schedule| schedule.date.after?(from) && schedule.date.defore?(to) }
    schedules.each do |schedule|
      if schedule.use_details.count >= 20  # 施設の床数にする
        flash.now[:alert] = "満床の日程があるため予約確定できませんでした。"
        redirect_to care_manager_use_plan_path(@use_plan)
      end
    end

    # 施設のスケジュールに反映する
    (from..to).each do |date|
      schedule = @booking_contact.facility.schedules.new
      schedule.update(date: date)
      use_detail = schedule.use_details.new
      if date == from
        status = "in"
      elsif date == to
        status = "out"
      else
        status = "all_day"
      end
      use_detail.update(user_id: @use_plan.user_id, status: status)
    end


    # 利用計画に利用先施設を設定し、ステータスを予約完了にする
    if @use_plan.update(facility_id: @booking_contact.facility_id, status: "confirmed")
      flash.now[:notice] = "利用先施設を「#{@booking_contact.facility.name}」に確定しました。"
      # 利用計画の問い合わせをすべて問い合わせ終了にする
      if @use_plan.booking_contacts.update_all(status: "closing")
        flash.now[:notice] += "問い合わせを締め切りました。"
      else
        flash.now[:alert] += "問い合わせの締め切りに失敗しました"
      end
    else
      flash.now[:alert] += "利用先の確定に失敗しました。"
    end
    @facilities = Facility.all
    @booking_contacts = @use_plan.booking_contacts
    render 'care_manager/use_plans/show'
  end

  private

  def booking_contact_params
    params.require(:booking_contact).permit(:facility_id)
  end

  def ensure_correct_care_manager
    @use_plan = UsePlan.find(params[:use_plan_id])

    # URLで他ケアマネージャーがアクセスした場合に問い合わせ処理を禁止する
    unless @use_plan.care_manager_id == current_care_manager.id
      redirect_to care_manager_use_plan_path(@use_plan), alert: '他のケアマネージャーの利用計画での問い合わせ処理はできません。'
    end

    # 利用予約が予約確定している場合は問い合わせ処理を禁止する
    if @use_plan.status == "confirmed"
      redirect_to care_manager_use_plan_path(@use_plan), alert: '予約確定している利用計画の問い合わせ処理はできません。'
    end
  end
end
