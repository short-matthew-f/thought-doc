class PollsController < ApplicationController
  before_filter :ensure_current_user

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @poll   = @lesson.polls.new(poll_params)

    if @poll.save
      render json: @poll
    else
      render json: {
        error: true,
        message: @poll.errors.full_messages.to_sentence
      }
    end
  end

  def destroy
    Poll.destroy(params[:id])

    render json: {
      error: false,
      message: "Successful destruction of poll",
      poll: @poll
    }
  end

  def stats
    @poll = Poll.find(params[:poll_id])

    render json: {
      poll: @poll,
      choices: @poll.choices_with_count
    }
  end

  def toggle
    @poll = Poll.find(params[:poll_id])
    @poll.update(active: !@poll.active)

    render json: @poll
  end

  private

  def poll_params
    params.require(:poll)
          .permit(:question, choices_attributes: [:content])
  end
end
