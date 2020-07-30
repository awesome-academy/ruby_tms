class SubjectsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_course, :load_subject, only: :show

  def show
    @tasks = @subject.tasks.sort_by_name.paginate(page: params[:page],
      per_page: Settings.subject.show.paginate.task)
  end

  private

  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course&.avaiable?

    flash[:warning] = t "courses.load_course.not_found"
    redirect_to root_path
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject

    flash[:warning] = t "subjects.load_subject.not_found"
    redirect_to root_path
  end
end
