class Admin::SearchsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_trainer?
  before_action :load_course, only: %i(search_user_by_name search_subject_by_name)

  def search_user_by_name
    @search_users = User.search_by_name_and_not_in_course(params[:name], @course.users_ids)
  end

  def search_subject_by_name
    unless @course.subjects.ids.present?
      @subjects = Subject.search_by_name params[:name]
      return if @subjects
    end
    @subjects = Subject.by_name_without_ids params[:name], @course.subjects_ids
  end

  def search_course_by_name_or_description
    @q = Course.ransack(params[:q].try(:merge, m: "or"))
    @courses = @q.result.avaiable.paginate(page: params[:page])
  end

  private

  def load_course
    @course = Course.find_by id: params[:course_id]
    return @course && !@course.deleted?

    flash[:warning] = t "courses.load_course.not_found"
    redirect_to root_path
  end
end
