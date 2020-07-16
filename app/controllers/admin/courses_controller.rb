class Admin::CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :load_course, :load_added_subjects, only: %i(show edit update)
  before_action :is_owner?, only: %i(edit update)
  before_action :build_course, only: :create

  def new
    @course = Course.new
  end

  def create
    @course.transaction do
      @course.save!
      UserCourse.create! user: current_user, course: @course
    end
    flash[:success] = t "admin.courses.create.success_message"
    redirect_to admin_courses_path
  rescue
    flash.now[:danger] = t "admin.courses.create.fail_message"
    render :new
  end

  def index
    @courses = Course.newest.paginate(page: params[:page])
  end

  def show
    @users = @course.users.sort_by_name_role.paginate(page: params[:user_page],
      per_page: Settings.course.show.paginate.member)
  end

  def edit; end

  def update
    if @course.update course_edit_params
      flash[:success] = t "admin.courses.edit.success_message"
      redirect_to [:admin, @course]
    else
      render :edit
    end
  end

  private

  def course_create_params
    params.require(:course).permit(:name, :description)
  end

  def course_edit_params
    params.require(:course).permit(:name, :description, :status)
  end

  def build_course
    @course = current_user.courses.build course_create_params
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course

    flash[:warning] = t "courses.load_course.not_found"
    redirect_to root_path
  end

  def is_owner?
    return if current_user.user_courses.find_by(course_id: @course.id)&.owner?

    flash[:danger] = t "application.is_owner.not_permit"
    redirect_to admin_course_path
  end

  def load_added_subjects
    subjects = @course.subjects.newest
    @added_subjects = Hash.new
    subjects.each do |ad|
      @added_subjects.store(ad, load_subject_status(ad, @course))
    end
  end

  def load_subject_status subject, course
    subject.course_details.find_by(course_id: course.id).status.humanize
  end
end
