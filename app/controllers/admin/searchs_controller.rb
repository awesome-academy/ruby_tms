class Admin::SearchsController < ApplicationController
  before_action :logged_in_user
  before_action :load_course, only: %i(search_user_by_name search_subject_by_name)

  def search_user_by_name
    @search_users = User.search(params[:name], @course.users.ids)
  end

  def search_subject_by_name
    unless @course.subjects.ids.present?
      @subjects = Subject.search_by_name params[:name]
      return if @subjects
    end
    @subjects = Subject.by_name_without_ids params[:name], @course.subjects.ids
  end

  private

  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:warning] = t "courses.load_course.not_found"
    redirect_to root_path
  end
end
