class Facility::UsePlanCommentsController < ApplicationController
  before_action :authenticate_facility!
  before_action :ensure_correct_facility, only: [:create]

  def create
    booking_contact = BookingContact.find(params[:booking_contact_id])
    use_plan = booking_contact.use_plan
    use_plan_comment = use_plan.use_plan_comments.new(use_plan_comment_params)
    use_plan_comment.score = Language.get_data(use_plan_comment.comment)
    use_plan_comment.speaker_id = booking_contact.facility_id
    use_plan_comment.save
    redirect_to request.referer, notice: 'コメントを投稿しました。'
  end

  private

  def use_plan_comment_params
    params.require(:use_plan_comment).permit(:use_plan_id, :comment, :speaker_id)
  end

  def ensure_correct_facility
    booking_contact = BookingContact.find(params[:booking_contact_id])
    unless booking_contact.facility_id == current_facility.id
      redirect_to request.referer, alert: 'この操作は行えません。'
    end
  end
end
