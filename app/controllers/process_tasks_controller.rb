class ProcessTasksController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_course, :check_status_of_course, :load_subject, :load_subject_within_course,
    :load_user_subject, :admin_check_status_of_subject_within_course,
    :member_check_status_of_subject_within_course, :load_process_task, only: :update

  def update
    ActiveRecord::Base.transaction do
      @process_task.update! status: ProcessTask.statuses[params[:status].to_s]
      @tasks = @subject.tasks
    end
  rescue
    flash[:warning] = t "process_tasks.update.failed"
    redirect_to @course
  end

  private

  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course&.avaiable?

    flash[:warning] = t "process_tasks.load_course.not_found"
    redirect_to root_path
  end

  def load_subject
    @subject = Subject.find_by id: params[:subject_id]
    return if @subject

    flash[:warning] = t "process_tasks.load_subject.not_found"
    redirect_to @course
  end

  def load_subject_within_course
    @course_detail = @course.course_details.find_by subject_id: params[:subject_id]
    return if @course_detail

    flash[:warning] = t "process_tasks.load_subject_within_course.not_found"
    redirect_to @course
  end

  def load_user_subject
    @user_subject = current_user.user_subjects.find_by subject_id: params[:subject_id]
    return if @user_subject

    flash[:warning] = t "process_tasks.load_user_subject.not_found"
    redirect_to @course
  end

  def load_process_task
    @process_task = current_user.process_tasks.find_by task_id: params[:task_id]
    return if @process_task

    flash[:warning] = t "process_tasks.load_process_task.not_found"
    redirect_to [@course, @subject]
  end

  def check_status_of_course
    return if @course.open?

    flash[:warning] = t "process_tasks.check_status_of_course.message"
    redirect_to @course
  end

  def admin_check_status_of_subject_within_course
    return if @course_detail.open?

    flash[:warning] = t "process_tasks.admin_check_status_of_subject_within_course.message"
    redirect_to [@course, @subject]
  end

  def member_check_status_of_subject_within_course
    return if @user_subject.open?

    flash[:warning] = t "process_tasks.member_check_status_of_subject_within_course.message"
    redirect_to [@course, @subject]
  end
end
