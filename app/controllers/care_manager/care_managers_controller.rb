class CareManager::CareManagersController < ApplicationController
  def show
  end

  def edit
    @care_manager = current_care_manager
  end

  def update
    if current_care_manager.update(care_manager_params)
      redirect_to care_managers_path, notice: "登録情報を編集しました。"
    else
      flash[:alert] = "エラーが発生しました。"
      @care_manager = current_care_manager
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    customer = current_customer
    customer.update(is_deleted: true)
    reset_session
    flash[:alert] = "退会が完了しました。"
    redirect_to root_path
  end

  private

  def care_manager_params
    params.require(:care_manager).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :post_code, :address, :phone_number, :email, :office_name)
  end
end
