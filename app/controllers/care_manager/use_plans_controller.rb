class CareManager::UsePlansController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:show, :edit, :update, :select]

  def index
    @use_plan = UsePlan.new
    @use_plans = current_care_manager.use_plans
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
          redirect_to care_manager_use_plans_path(@use_plan), notice: "利用計画が正常に作成されました。"
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
    @facilities = Facility.all
    @booking_contacts = @use_plan.booking_contacts
  end

  def edit
  end

  def update
    if UsePlan.new(use_plan_params).correct_date?
      if @use_plan.update(use_plan_params)
        redirect_to care_manager_use_plans_path(@use_plan), notice: '利用計画が正常に更新されました。'
      else
        flash.now[:alert] = "利用計画更新中にエラーが発生しました。"
        render :edit
      end
    else
      flash.now[:alert] = "入力された日付に問題があります。"
      render :edit
    end
  end

  # 問い合わせ先選択画面表示
  def select
    # 契約済み施設を取得
    # @facilities = @use_plan.user.contracts.map { |x| x.facility }
    @facilities = Facility.all
    @booking_contact = BookingContact.new

    # 施設検索機能
    w = params[:word]
    if w != nil
      s = params[:search]
      @range = params[:range] # 検索結果に表示

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
      if @range == "Name"
        @facilities = Facility.where("name LIKE?", w)
      else
        @facilities = Facility.where("address LIKE?", w)
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
