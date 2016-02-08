class StudentsController < ApplicationController
  def index
  end

  def lesson
    render :lesson, layout: "student"
  end

  def pending
    @lesson = Lesson.includes(polls: { choices: :votes })
                .find_by(token: params[:lesson_token])

    @pending_polls = @lesson.polls
      .where(active: true).reject do |x|
      x.votes.any? { |y| y.token == cookies[:token] }
    end

    # render json: {
    #   lesson: @lesson,
    #   pendingPolls: @pending_polls
    # }
  end

  def finished
    @lesson = Lesson.includes(polls: { choices: :votes })
                .find_by(token: params[:lesson_token])

    @finished_polls = @lesson.polls.select do |x|
      x.votes.any? { |y| y.token == cookies[:token] } &&
      x.active
    end

    render json: {
      lesson: @lesson,
      finishedPolls: @finished_polls
    }
  end

  def vote
    @choice = Choice.find(params[:choice_id])
    @vote = @choice.votes.new(token: cookies[:token])

    if @vote.save
      render json: {
        success: true,
        message: 'Vote Successful'
      }
    else
      render json: {
        success: false,
        message: @vote.errors.full_messages.to_sentence
      }
    end
  end
end
