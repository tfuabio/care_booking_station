class CareManager::UsersController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.care_manager_id = current_care_manager.id
    if @user.save
      redirect_to care_manager_user_path(@user), notice: "利用者情報が正常に作成されました。"
    else
      flash[:alert] = "利用者情報作成中にエラーが発生しました。"
      render :new
    end
  end

  def index
    @users = current_care_manager.users
  end

  def show
    @user = User.find(params[:id])
    @emergency_contact = EmergencyContact.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to care_manager_user_path(@user), notice: '利用者情報が正常に更新されました。'
    else
      flash[:alert] = "利用者情報更新中にエラーが発生しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :address, :post_code, :phone_number, :current_status, :care_level_status, :gender, :birthday, :life_history, :medical_history, :image)
  end

  def ensure_correct_care_manager
    user = User.find(params[:id])
    unless user.care_manager_id == current_care_manager.id
      redirect_to care_manager_users_path, alert: '他のケアマネージャーが作成したご利用者様情報は閲覧できません。'
    end
  end
end