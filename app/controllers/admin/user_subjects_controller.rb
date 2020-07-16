class Admin::UserSubjectsController < ApplicationController
  before_action :load_course, :load_user, only: %i(index)
  before_action :load_user_subjects, only: :index
  
  def index; end

  def show; end
  
  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:warning] = t ".load_course"
    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:warning] = t ".load_user"
    redirect_to root_path
  end

  def load_user_subjects
    unless @course.users.find_by id: @user.id
      flash[:danger] = t ".user_not_joined_this_course"
      redirect_to root_path
    end
    subjects_in_course = @course.subjects
    @user_subjects = Hash.new
    subjects_in_course.each do |sic|
      @user_subjects.store(sic, check_subject_status(sic))
    end
    return if @user_subjects

    flash[:warning] = t ".load_user_subjects"
    redirect_to root_path
  end

  def check_subject_status subject
    us = UserSubject.find_by id: subject.id
    us.present? ? us.status : I18n.t("admin.user_subjects.check_subject_status.not_start_yet")
  end

  def load_user_subject
    @user_subject = UserSubject.find_by id: params[:id]
    return if @user_subject

    flash[:warning] = t ".load_user_subject"
    redirect_to root_path
  end
end
