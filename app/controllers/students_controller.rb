class StudentsController < ApplicationController
  def lesson
    @lesson = Lesson.includes(polls: { choices: :votes })
                .find_by(token: params[:lesson_token])

    @taken_polls = @lesson.polls.select do |x|
      x.votes.any? { |y| y.token == cookies[:token] } &&
      x.active
    end

    @pending_polls = @lesson.polls
      .where(active: true).reject do |x|
      x.votes.any? { |y| y.token == cookies[:token] }
    end
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
