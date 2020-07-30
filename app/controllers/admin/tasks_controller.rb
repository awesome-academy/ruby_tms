class Admin::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :is_trainer?
  before_action :load_subject, :load_task, only: %i(show edit update)

  def show; end

  def edit; end

  def update
    if @task.update task_params
      flash[:success] = t ".success"
      redirect_to [:admin, @subject]
    else
      render :edit
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def load_subject
    @subject = Subject.find_by id: params[:subject_id]
    return if @subject

    flash[:warning] = t "subjects.load_subject.not_found"
    redirect_to root_path
  end

  def load_task
    @task = Task.find_by id: params[:id]
    return if @task

    flash[:warning] = t "tasks.load_task.not_found"
    redirect_to root_path
  end
end
