class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:update, :destroy, :toggle]

  def index
    @tasks = current_user.tasks.order(due_date: :asc)
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'やることを作成しました'
    else
      @tasks = current_user.tasks.order(due_date: :asc)
      render :index
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'やることを削除しました'
  end

  def toggle
    @task.update(completed: !@task.completed)
    redirect_to tasks_path
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
