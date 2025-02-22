class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def index
    @tasks = current_user.tasks.order(due_date: :asc)
    @task = Task.new
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('tasks', partial: 'tasks/task', locals: { task: @task }),
            turbo_stream.replace('modal', '')  # モーダルを閉じる
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('task-form', partial: 'tasks/form', locals: { task: @task })
        end
      end
    end
  end

  def edit
    render layout: false
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("task_#{@task.id}", partial: 'tasks/task', locals: { task: @task }),
            turbo_stream.replace('modal', '')  # モーダルを閉じる
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('task-form', partial: 'tasks/form', locals: { task: @task })
        end
      end
    end
  end

  def destroy
    @task.destroy
  
    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("task_#{@task.id}") }
    end
  end

  def toggle
    @task = current_user.tasks.find(params[:id])
    @task.update(completed: !@task.completed)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
