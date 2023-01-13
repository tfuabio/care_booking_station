class CareManager::UsePlansController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:show, :edit, :update]

  def new
    @use_plan = UsePlan.new
  end

  def create
    @use_plan = UsePlan.new(use_plan_params)
    if @use_plan.correct_date?  # 日付が正しいか判定します
      @use_plan.care_manager_id = current_care_manager.id
      if @use_plan.save
        redirect_to care_manager_use_plans_path(@use_plan), notice: "利用計画が正常に作成されました。"
      else
        flash[:alert] = "利用計画作成中にエラーが発生しました。"
        render :new
      end
    else
      flash[:alert] = "入力された日付に問題があります。"
      render :new
    end
  end

  def show
    @use_plan = UsePlan.find(params[:id])
    @booking_contacts = BookingContact.new
    @facilities = Facility.all
  end

  def edit
    @use_plan = UsePlan.find(params[:id])
  end

  def index
    @use_plans = current_care_manager.use_plans
  end

  def update
    @use_plan = UsePlan.find(params[:id])
    if UsePlan.new(use_plan_params).correct_date?
      if @use_plan.update(use_plan_params)
        redirect_to care_manager_use_plans_path(@use_plan), notice: '利用計画が正常に更新されました。'
      else
        flash[:alert] = "利用計画更新中にエラーが発生しました。"
        render :edit
      end
    else
      flash[:alert] = "入力された日付に問題があります。"
      render :edit
    end
  end

  private

  def use_plan_params
    params.require(:use_plan).permit(:user_id, :start_date, :end_date, :status)
  end

  def ensure_correct_care_manager
    use_plan = UsePlan.find(params[:id])
    unless use_plan.care_manager_id == current_care_manager.id
      redirect_to care_manager_users_path, notice: '他のケアマネージャーが作成したご利用者様情報は閲覧できません。'
    end
  end
end
