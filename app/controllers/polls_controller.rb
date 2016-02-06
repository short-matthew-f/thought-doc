class PollsController < ApplicationController
  before_filter :ensure_current_user

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @poll   = @lesson.polls.new
    4.times { @poll.choices.build }
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @poll   = @lesson.polls.new(poll_params)

    if @poll.save
      redirect_to @poll
    else
      flash[:error] = @poll.errors.full_messages.to_sentence

      while @poll.choices.size < 4 do
        @poll.choices.build
      end

      render :new
    end
  end

  def show
    @poll    = Poll.includes(:choices).find(params[:id])
    @lesson  = @poll.lesson
    @choices = @poll.choices.order(:id)
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

    redirect_to @poll
  end

  private

  def poll_params
    params.require(:poll)
          .permit(:question, choices_attributes: [:content])
  end
end
