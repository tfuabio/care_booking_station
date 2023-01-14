class CareManager::BookingContactsController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:create, :determine]

  def create
    booking_contact = @use_plan.booking_contacts.new(booking_contact_params)
    facility = booking_contact.facility
    if booking_contact.contacted?  # 問い合わせ済みか確認
      flash.now[:alert] = "問い合わせ済みのため#{facility.name}への問い合わせ送信を中止しました。"
    elsif booking_contact.no_beds?  # 空きがあるか確認
      flash.now[:alert] = "満床の日程があるため#{facility.name}へ問い合わせを送信できませんでした。"
    else
      if booking_contact.save
        flash.now[:notice] = "#{facility.name}へ問い合わせを送信しました。"
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

  # 予約確定処理
  def determine
    booking_contact = BookingContact.find(params[:booking_contact_id])
    facility = booking_contact.facility

    # 施設の空きがあるか確認
    if booking_contact.no_beds?
      flash.now[:alert] = "満床の日程があるため予約確定できませんでした。"
      redirect_to care_manager_use_plan_path(@use_plan)
    end

    # 施設スケジュールに反映
    booking_contact.add_schdule

    # 利用計画に利用先施設を設定し、ステータスを予約完了にする
    if @use_plan.update(facility_id: facility.id, status: "confirmed")
      flash.now[:notice] = "利用先施設を「#{facility.name}」に確定しました。"
      # 利用計画の問い合わせをすべて問い合わせ終了にする
      if @use_plan.booking_contacts.update_all(status: "closing")
        flash.now[:notice] += "問い合わせを締め切りました。"
      else
        flash.now[:alert] = "問い合わせの締め切りに失敗しました"
      end
    else
      flash.now[:alert] = "利用先の確定に失敗しました。"
    end
    @booking_contact = BookingContact.new
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
