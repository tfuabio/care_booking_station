class Facility::FacilitiesController < ApplicationController
  # before_action :ensure_guest_facility

  def show
  end

  def edit
    @facility = current_facility
  end

  def update
    if current_facility.update(facility_params)
      redirect_to facilities_path, notice: "登録情報を編集しました。"
    else
      flash[:alert] = "エラーが発生しました。"
      @facility = current_facility
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    current_facility.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会が完了しました。"
  end

  private

  def facility_params
    params.require(:facility).permit(:name,:kana_name, :post_code, :address, :phone_number, :capacity, :email, :password, :password_confirmation)
  end

  # def ensure_guest_facility
  #   if current_facility.email == "guest@example.com"
  #     redirect_to root_path, notice: 'ゲストユーザーはプロフィール編集を行えません。'
  #   end
  # end
end
