# frozen_string_literal: true

class Facility::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :facility_state, only: [:create]

  def guest_sign_in
    facility = Facility.guest
    sign_in facility
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
  def facility_state
    ## 入力されたemailからアカウントを1件取得
    @facility = Facility.find_by(email: params[:facility][:email])
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@facility
    ## 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
    if @facility.valid_password?(params[:facility][:password]) && (@facility.is_deleted == false)
      root_path
    else
      flash[:alert] = "退会済みのアカウントのためログインできませんでした。"
      redirect_to new_facility_registration_path
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
