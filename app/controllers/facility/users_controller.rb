class Facility::UsersController < ApplicationController
  before_action :authenticate_facility!
  before_action :ensure_correct_facility, only: [:show, :contract_change]

  def index
    @users = facility.contracts
  end

  def show
    @is_contracted = current_facility.new_user?(@user)
  end

  # 利用者の契約状態を切り替えるアクション
  def contract_change
    contract = Contract.find_by(facility_id: current_facility.id, user_id: @user.id)
    if contract.is_contracted
      contract.update(is_contracted: false)
      flash[:notice] = "#{@user.full_name} 様の契約状態を未契約にしました。"
    else
      contract.update(is_contracted: true)
      flash[:notice] = "#{@user.full_name} 様を契約状態を契約済にしました。"
    end
    @is_contracted = contract.is_contracted
    render :show
  end

  private

  def ensure_correct_facility
    @user = User.find(params[:id])
    unless @user.contracts.exists?(facility_id: current_facility.id)
      redirect_to request.referer, alert: '契約記録のないご利用者様情報は閲覧できません。'
    end
  end
end
