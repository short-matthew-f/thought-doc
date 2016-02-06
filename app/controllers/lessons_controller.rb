class LessonsController < ApplicationController
  before_filter :ensure_current_user

  def index
    @lessons = current_user.lessons
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = current_user.lessons.new(lesson_params)

    if @lesson.save
      redirect_to lessons_path
    else
      flash[:error] = @lesson.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @lesson = Lesson.includes(:polls)
                    .find(params[:id])

    redirect_to current_user unless @lesson.user_id == current_user.id
  end

  private

  def lesson_params
    params.require(:lesson)
          .permit(:title, :github_url)
  end
end
