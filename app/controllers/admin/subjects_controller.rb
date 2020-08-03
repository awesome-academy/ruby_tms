class Admin::SubjectsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :is_trainer?
  before_action :build_subject, only: :create
  before_action :load_subject, only: %i(show edit update)

  def new
    @subject = Subject.new
    @subject.tasks.build
  end

  def index
    @subjects = Subject.sort_by_name
  end

  def show
    @tasks = @subject.tasks.sort_by_name.paginate(page: params[:page],
      per_page: Settings.subject.show.paginate.task)
  end

  def create
    if @subject.save
      flash[:success] = t "admin.subjects.create.success_message"
      redirect_to root_path
    else
      @subject.tasks || @subject.tasks.build
      render :new
    end
  end

  def edit; end

  def update
    if @subject.update subject_params
      flash[:success] = t ".success"
      redirect_to [:admin, @subject]
    else
      render :edit
    end
  end

  private

  def subject_params
    params.require(:subject).permit(:name, :description, :duration, tasks_attributes: [:name, :description])
  end

  def build_subject
    @subject = Subject.new subject_params
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject

    flash[:warning] = t "admin.subjects.load_subject.not_found"
    redirect_to root_path
  end
end
