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
    # 入力されたemail
    email = params[:care_manager][:email]
    ## 入力されたemailからアカウントを1件取得
    @care_manager = CareManager.find_by(email: email)
    if !@care_manager
      # アカウントを取得できなかった場合
      redirect_to sign_in_path, alert: "#{email}は登録されていないためログインできませんでした。"
    else
      # 退会しているかを判断
      if @care_manager.is_deleted == false
        return if @care_manager.valid_password?(params[:care_manager][:password])  # 入力されたパスワードが一致している場合このメソッドを終了
        redirect_to sign_in_path, alert: "パスワードが一致していないためログインできませんでした。"
      else
        redirect_to sign_in_path, alert: "退会済みのアカウントのためログインできませんでした。"
      end
    end
  end

  def after_sign_in_path_for(resource)
    flash[:notice] = "#{@care_manager.full_name}でログインしました。"
    root_path
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました。"
    root_path
  end
end
