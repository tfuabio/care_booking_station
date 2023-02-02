class CareManager::UsePlanCommentsController < ApplicationController
  before_action :authenticate_care_manager!
  before_action :ensure_correct_care_manager, only: [:create]

  def create
    use_plan = UsePlan.find(params[:use_plan_id])
    use_plan_comment = use_plan.use_plan_comments.new(use_plan_comment_params)
    use_plan_comment.score = Language.get_data(use_plan_comment.comment)
    use_plan_comment.save
    redirect_to request.referer, notice: 'コメントを投稿しました。'
  end

  private

  def use_plan_comment_params
    params.require(:use_plan_comment).permit(:use_plan_id, :comment, :is_facility)
  end

  def ensure_correct_care_manager
    @use_plan = UsePlan.find(params[:use_plan_id])
    unless @use_plan.care_manager_id == current_care_manager.id
      redirect_to request.referer, alert: 'この操作は行えません。'
    end
  end
end
