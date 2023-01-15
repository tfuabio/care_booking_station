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

  # ログインできるか判断するメソッド
  def facility_state
    ## 入力されたemailからアカウントを1件取得
    @facility = Facility.find_by(email: params[:facility][:email])
    if !@facility
      # アカウントを取得できなかった場合
      redirect_to new_facility_session_path, alert: "#{@facility.email}は登録されていないためログインできませんでした。"
    else
      # 退会しているかを判断
      if @facility.is_deleted == false
        return if @facility.valid_password?(params[:facility][:password])  # 入力されたパスワードが一致している場合このメソッドを終了
        redirect_to new_facility_session_path, alert: "パスワードが一致していないためログインできませんでした。"
      else
        redirect_to new_facility_registration_path, alert: "退会済みのアカウントのためログインできませんでした。"
      end
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
