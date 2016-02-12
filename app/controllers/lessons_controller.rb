class LessonsController < ApplicationController
  before_filter :ensure_current_user

  def home
    render :home, layout: 'instructor'
  end

  def index
    @lessons = Lesson.includes(polls: :choices)
                .where(user: current_user)
  end

  def create
    @lesson = current_user
                .lessons.new(lesson_params)

    if @lesson.save
      render json: @lesson
    else
      render json: {
        error: true,
        message: @lesson.errors.full_messages.to_sentence
      }
    end
  end

  def destroy
    Lesson.destroy(params[:id])

    render json: {
      error: false,
      message: "Successful destruction of poll",
      poll: @poll
    }
  end

  private

  def lesson_params
    params.require(:lesson)
          .permit(:title, :github_url)
  end
end
