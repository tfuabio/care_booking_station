# frozen_string_literal: true

class CareManager::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :care_manager_state, only: [:create]

  def guest_sign_in
    care_manager = CareManager.guest
    sign_in care_manager
    redirect_to root_path, notice: 'ゲストログインしました。'
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # 退会しているかを判断するメソッド
  def care_manager_state
    ## 入力されたemailからアカウントを1件取得
    @care_manager = CareManager.find_by(email: params[:care_manager][:email])
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@care_manager
    ## 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
    if @care_manager.valid_password?(params[:care_manager][:password]) && (@care_manager.is_deleted == false)
      root_path
    else
      flash[:alert] = "退会済みのアカウントのためログインできませんでした。"
      redirect_to new_care_manager_registration_path
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
