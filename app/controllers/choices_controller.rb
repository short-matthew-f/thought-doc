class ChoicesController < ApplicationController
  before_filter :ensure_current_user
  
  def mark_correct
    @choice = Choice.find(params[:choice_id])
    @choice.update(correct: true)

    @poll = @choice.poll
    @poll.choices.each do |choice|
      choice.update(correct: false) if choice.correct && choice != @choice
    end

    render json: @choice
  end
end
