class Admin::UserCoursesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_existing_users, :load_existing_course, :is_trainer?, only: :create

  def create
    ActiveRecord::Base.transaction do
      @user_ids.each do |id|
        @user_course = @existing_course.user_courses.create! user_id: id, role: UserCourse.roles[:trainee]
      end
    end
    @users = @existing_course.users.paginate(page: params[:page], per_page: Settings.course.show.paginate.member)
    @course = @existing_course
  rescue
    flash.now[:warning] = t "courses.add_existing_user.warning"
    redirect_to root_path
  end

  private

  def load_existing_users
    @user_ids = User.search_by_ids(JSON.parse(params[:user_ids])).pluck(:id)
    return if @user_ids

    flash[:warning] = t "courses.load_existing_users.not_found"
    redirect_to root_path
  end

  def load_existing_course
    @existing_course = Course.find_by id: params[:course_id]
    return if @existing_course && !@existing_course.deleted?

    flash[:warning] = t "courses.load_course.not_found"
    redirect_to root_path
  end
end
