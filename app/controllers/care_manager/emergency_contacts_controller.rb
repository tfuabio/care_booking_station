class CareManager::EmergencyContactsController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:create, :destroy]

  def create
    user = User.find(params[:user_id])
    emergency_contact = user.emergency_contacts.new(emergency_contact_params)
    if emergency_contact.save
      redirect_to care_manager_user_path(user), notice: "正常に緊急連絡先が登録されました。"
    else
      redirect_to care_manager_user_path(user), alert: "緊急連絡先の登録時にエラーが発生しました"
    end
  end

  def destroy
    user = User.find(params[:user_id])
    emergency_contact = user.emergency_contacts.find(params[:id])
    emergency_contact.destroy
    redirect_to care_manager_user_path(user), notice: "緊急連絡先(#{emergency_contact.full_name} 様)の情報が登録されました。"
  end

  private

  def emergency_contact_params
    params.require(:emergency_contact).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :address, :post_code, :phone_number, :relationship, :status)
  end

  def ensure_correct_care_manager
    user = User.find(params[:user_id])
    unless user.care_manager_id == current_care_manager.id
      redirect_to care_manager_user_path(user), alert: '他のケアマネージャーが作成したご利用者様情報は編集できません。'
    end
  end
end