class CareManager::UsersController < ApplicationController
  before_action :authenticate_care_manager!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.care_manager_id = current_care_manager.id
    if @user.save
      redirect_to care_manager_user_path(@user), notice: "利用者情報が作成されました。"
    else
      flash[:notice] = "エラーが発生しました。"
      render :new
    end
  end


  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :address, :post_code, :phone_number, :current_status, :care_level_status, :gender, :birthday, :life_history, :medical_history)
  end
end