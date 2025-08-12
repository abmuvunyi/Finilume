# app/controllers/feedbacks_controller.rb
class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.status ||= "open"

    if @feedback.save
      redirect_to root_path, notice: t("feedbacks.flash.created", default: "Thanks! Your feedback was sent.")
    else
      flash.now[:alert] = @feedback.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:email, :category, :message)
  end
end
