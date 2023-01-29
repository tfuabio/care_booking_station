class CareManager::BookingContactsController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:create, :determine]

  # 問い合わせ作成処理
  def create
    booking_contact = @use_plan.booking_contacts.new(booking_contact_params)
    facility = booking_contact.facility
    if booking_contact.contacted?  # 問い合わせ済みか確認
      flash[:alert] = "問い合わせ済みのため#{facility.name}への問い合わせ送信を中止しました。"
    else
      if booking_contact.no_beds?  # 空きがあるか確認
        flash[:alert] = "満床の日程があるため#{facility.name}へ問い合わせを送信できませんでした。"
      else
        if booking_contact.save
          flash[:notice] = "#{facility.name}へ問い合わせを送信しました。"
          @use_plan.update(status: "contacting")
        else
          flash[:alert] = "問い合わせに失敗しました。"
        end
      end
    end
    redirect_to care_manager_use_plan_path(@use_plan)
  end

  # 問い合わせに対する予約確定処理
  def determine
    booking_contact = BookingContact.find(params[:booking_contact_id])
    facility = booking_contact.facility

    # 施設の空きがあるか確認
    if booking_contact.no_beds?
      flash[:alert] = "満床の日程があるため予約確定できませんでした。"
      redirect_to care_manager_use_plan_path(@use_plan)
      return
    end

    # 施設スケジュールに反映
    unless booking_contact.save_schdule
      flash[:alert] = "aaa予約確定に失敗しました。"
      redirect_to care_manager_use_plan_path(@use_plan)
      return
    end

    # 利用計画に利用先施設を設定し、ステータスを予約確定にする
    if @use_plan.update(facility_id: facility.id, status: "confirmed")
      flash[:notice] = "利用先施設を「#{facility.name}」に確定しました。"

      # 利用計画の問い合わせをすべて問い合わせ終了にする
      if @use_plan.booking_contacts.update_all(status: "closing")
        flash[:notice] += "問い合わせを締め切りました。"
      else
        flash[:alert] = "問い合わせの締め切りに失敗しました"
      end

      # 施設と利用者間の契約がない場合
      if booking_contact.new_user?
        contract = @use_plan.user.contracts.new
        contract.facility_id = facility.id
        if contract.save
          flash[:notice] += "#{facility.name}へ#{@use_plan.user.full_name}様の利用者情報の閲覧許可を付与しました。"
        else
          flash[:alert] += "予約確定に失敗しました。"
        end
      end
    else
      flash[:alert] = "予約確定に失敗しました。"
    end
    redirect_to care_manager_use_plan_path(@use_plan)
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
