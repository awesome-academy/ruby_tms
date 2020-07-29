class Admin::CourseDetailsController < ApplicationController
  before_action :logged_in_user
  before_action :is_trainer?, :load_course, only: %i(create update)
  before_action :load_existing_subject_ids, only: :create
  before_action :load_subject, :check_course_status, only: :update

  def create
    CourseDetail.transaction do
      @will_save_subject_ids.each do |sid|
        CourseDetail.create! status: CourseDetail.statuses[:pending], course_id: params[:course_id], subject_id: sid
      end

      load_course_subjects
    rescue
      flash.now[:warning] = t "admin.courses.add_existing_subject.warning"
      redirect_to root_path
    end
  end

  def update
    @course_detail = @course.course_details.find_by subject_id: @subject.id, course_id: @course.id
    @course_detail.update status: CourseDetail.statuses[params[:status].to_s]
    load_course_subjects
  end

  private

  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course&.avaiable?

    flash[:warning] = t "admin.courses.load_course.not_found"
    redirect_to root_path
  end

  def load_subject
    @subject = Subject.find_by id: params[:subject_id]
    return if @subject

    flash[:warning] = t "admin.courses.load_existing_subjects.not_found"
    redirect_to [:admin, @course]
  end

  def load_existing_subject_ids
    @will_save_subject_ids = (Subject.search_by_ids params[:subject_ids]).pluck(:id)
    return if @will_save_subject_ids.present?

    flash[:warning] = t "admin.courses.load_existing_subjects.not_found"
    redirect_to [:admin, @course]
  end

  def load_course_subjects
    subjects = @course.subjects.newest
    @added_subjects = Hash.new
    subjects.each do |ad|
      @added_subjects.store(ad, load_subject_status(ad, @course))
    end
  end

  def load_subject_status subject, course
    subject.course_details.find_by(course_id: course.id).status.humanize
  end

  def check_course_status
    unless @course.status == Course.statuses.key(Course.statuses[:open])
      flash[:warning] = t "admin.course_details.update.course_is_pending_or_closed"
      redirect_to [:admin, @course]
    end
  end
end
