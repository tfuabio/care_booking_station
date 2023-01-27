class CareManager::UsePlansController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:show, :edit, :update, :cancel]

  def index
    @use_plan = UsePlan.new
    @users = current_care_manager.users
    @use_plans = current_care_manager.use_plans

    # ビューで選択されたステータスによってフィルタする
    @status = params[:status]
    @status = 'all' if @status.blank?
    @use_plans = @use_plans.where(status: @status) unless @status == 'all'

    # 選んだユーザーの投稿だけにする
    @user_id = params[:user_id]
    unless @user_id.blank?
      @use_plans = @use_plans.where(user_id: @user_id)
      @use_plan.user_id = @user_id
    end

    # 最新順に並び変える
    @use_plans = @use_plans.sort_by{ |x| x.created_at }.reverse
  end

  def create
    @use_plan = UsePlan.new(use_plan_params)
    @use_plans = current_care_manager.use_plans
    if @use_plan.correct_date?  # 日付が正しいか判定
      @use_plan.care_manager_id = current_care_manager.id
      if @use_plan.duplicate?  # 日付が登録済みの計画と重複していないか判定
        flash.now[:alert] = "入力された日付がすでに登録されている計画と重複しています。"
        render :index
      else
        if @use_plan.save
          redirect_to care_manager_use_plan_path(@use_plan), notice: "利用計画が正常に作成されました。"
        else
          flash.now[:alert] = "利用計画作成中にエラーが発生しました。"
          render :index
        end
      end
    else
      flash.now[:alert] = "入力された日付に問題があります。"
      render :index
    end
  end

  def show
    @booking_contact = BookingContact.new
    @booking_contacts = @use_plan.booking_contacts

    # 契約済み施設を取得
    @facilities = @use_plan.user.contracts.where(is_contracted: true).map { |x| x.facility }

    # 施設検索機能
    w = params[:word]
    unless w == nil || w.blank?
      s = params[:search]
      range = params[:range] # 検索結果に表示

      # 検索方法によって分岐
      if s ==  "partial_match"
        @word = "「#{w}」を含む"
        w = "%#{w}%"
      elsif s == "forward_match"
        @word = "「#{w}」から始まる"
        w = "#{w}%"
      elsif s == "backward_match"
        @word = "「#{w}」で終わる"
        w = "%#{w}"
      else
        @word = "「#{w}」に完全一致"
      end

      # 検索対象によって分岐
      if range == "Name"
        @facilities = Facility.where("name LIKE?", w)
        @word += "施設名"
      else
        @facilities = Facility.where("address LIKE?", w)
        @word += "住所"
      end
    else

    end
  end

  def edit
    if @use_plan.status == "confirmed" || @use_plan.status == "canceled"
      redirect_to request.referer, alert: "予約確定またはキャンセルとなった利用計画は編集できません。"
    end
  end

  def update
    if UsePlan.new(use_plan_params).correct_date?
      if @use_plan.update(use_plan_params)
        redirect_to care_manager_use_plan_path(@use_plan), notice: '利用計画が正常に更新されました。'
      else
        flash.now[:alert] = "利用計画更新中にエラーが発生しました。"
        render :edit
      end
    else
      flash.now[:alert] = "入力された日付に問題があります。"
      render :edit
    end
  end

  # 利用計画を中止にするアクション
  def cancel
    @booking_contacts = @use_plan.booking_contacts
    status = @use_plan.status
    if status == "canceled"
      # 中止されている場合
      flash.now[:alert] = "この処理はできません"
    elsif status == "planning"
      if @use_plan.update(status: "canceled")
        redirect_to care_manager_use_plan_path(@use_plan), notice: "この利用計画を中止にしました。"
      else
        flash.now[:alert] = "処理中にエラーが発生しました。"
        render :show
      end
    elsif status == "contacting"
      # 問い合わせ中の場合
      # 利用計画の問い合わせをすべて問い合わせ終了にする
      if @use_plan.booking_contacts.update_all(status: "closing")
        flash[:notice] = "問い合わせを締め切りました。"
        if @use_plan.update(status: "canceled")
          flash[:notice] += "この利用計画を中止にしました。"
          redirect_to care_manager_use_plan_path(@use_plan)
        else
          flash.now[:alert] = "処理中にエラーが発生しました。"
          render :show
        end
      else
        flash.now[:alert] = "問い合わせの締め切りに失敗しました"
        render :show
      end
    elsif status == "confirmed"
      # 予約確定している場合
      if @use_plan.save_schdule("canceled")  # 施設スケジュールに中止として反映
        flash[:notice] = "#{@use_plan.facility.name}へ予約の中止を送信しました。"
        if @use_plan.update(status: "canceled")
          flash[:notice] += "この利用計画を中止にしました。"
          redirect_to care_manager_use_plan_path(@use_plan)
        else
          flash.now[:alert] = "処理中にエラーが発生しました。"
          render :show
        end
      else
        flash.now[:alert] = "問題が発生したため処理を終了しました。"
        render :show
      end
    end
  end

  private

  def use_plan_params
    params.require(:use_plan).permit(:user_id, :start_date, :end_date, :status)
  end

  def ensure_correct_care_manager
    @use_plan = UsePlan.find(params[:id])
    unless @use_plan.care_manager_id == current_care_manager.id
      redirect_to care_manager_use_plan_path(@use_plan), alert: '他のケアマネージャーが作成したご利用者様情報は閲覧・編集できません。'
    end
  end
end
