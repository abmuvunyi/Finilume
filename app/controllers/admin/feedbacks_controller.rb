# app/controllers/admin/feedbacks_controller.rb
class Admin::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_feedback, only: [:show, :update]

  def index
    scope = Feedback.order(created_at: :desc)
    scope = scope.where(status: params[:status]) if params[:status].present?
    @feedbacks = scope
    # If you install Kaminari/WillPaginate later, paginate here:
    # @feedbacks = scope.page(params[:page]).per(20)
  end

  def show; end

  def update
    if @feedback.update(feedback_params)
      redirect_to admin_feedback_path(@feedback),
                  notice: t("admin.feedbacks.flash.updated", default: "Feedback updated.")
    else
      flash.now[:alert] = @feedback.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:status)
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: t("unauthorized", default: "You are not authorized to perform this action.")
    end
  end
end
