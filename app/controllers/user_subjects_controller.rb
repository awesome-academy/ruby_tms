class UserSubjectsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_course, :check_status_closed_course, :load_subject, :check_exist_of_subject_within_course,
    :check_status_closed_subject, only: %i(create update)
  before_action :load_task_ids, only: :create
  before_action :load_user_subject, :check_duration_subject, only: :update

  def create
    ActiveRecord::Base.transaction do
      current_user.user_subjects.create! subject_id: @course_detail.subject_id
      @task_ids.each do |id|
        current_user.process_tasks.create! task_id: id
      end
      flash[:success] = t ".start_success"
      redirect_to @course
    end
  rescue
    flash.now[:warning] = t ".start_failed"
    redirect_to @course
  end

  def update
    ActiveRecord::Base.transaction do
      @user_subject.update! status: params[:status]
    end
    @added_subjects = @course.subjects.newest
  rescue
    flash[:warning] = t "user_subjects.update.failed"
    redirect_to @course
  end

  private

  def load_course
    course_id = params[:user_subject] ? params[:user_subject][:course_id] : params[:course_id]
    @course = Course.find_by id: course_id
    return if @course&.avaiable?

    flash[:warning] = t "user_subjects.load_course.not_found"
    redirect_to @course
  end

  def load_subject
    subject_id = params[:user_subject] ? params[:user_subject][:subject_id] : params[:subject_id]
    @subject = Subject.find_by id: subject_id
    return if @subject

    flash[:warning] = t "user_subjects.load_subject.not_found"
    redirect_to @course
  end

  def check_exist_of_subject_within_course
    course_id = params[:user_subject] ? params[:user_subject][:course_id] : params[:course_id]
    subject_id = params[:user_subject] ? params[:user_subject][:subject_id] : params[:subject_id]
    @course_detail = CourseDetail.find_by course_id: course_id, subject_id: subject_id
    return if @course_detail

    flash[:warning] = t "user_subjects.load_subject_within_course.not_found"
    redirect_to @course
  end

  def check_status_closed_course
    return if @course.open?

    flash[:warning] = t "user_subjects.check_status_of_course.message"
    redirect_to @course
  end

  def check_status_closed_subject
    return if @course_detail.open?

    flash[:warning] = t "user_subjects.check_status_closed_subject.message"
    redirect_to @course
  end

  def load_task_ids
    @task_ids = Subject.find_by(id: @course_detail.subject_id).tasks.ids
  end

  def load_user_subject
    @user_subject = current_user.user_subjects.find_by subject_id: params[:subject_id]
    return @user_subject

    flash[:warning] = t "user_subjects.load_user_subject.not_found"
    redirect_to @course
  end

  def check_duration_subject
    return unless @user_subject.created_at < @subject.duration.days.ago

    flash[:warning] = "user_subjects.check_duration_subject.expired"
    redirect_to @course
  end
end
