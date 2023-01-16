class Facility::UsersController < ApplicationController
  before_action :authenticate_facility!
  before_action :ensure_correct_facility, only: [:show]

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def ensure_correct_facility
    @user = User.find(params[:id])
    unless @user.contracts.exists?(facility_id: current_facility.id)
      redirect_to request.referer, alert: '契約記録のないご利用者様情報は閲覧できません。'
    end
  end
end
