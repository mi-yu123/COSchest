class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
    @task = Task.new
  end

  def new
    @task = current_user.tasks.new
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('tasks', partial: 'tasks/task', locals: { task: @task }),
            turbo_stream.replace('modal', ''),
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('modal', partial: 'tasks/form', locals: { task: @task }),
          ]
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("task_#{@task.id}", partial: 'tasks/task', locals: { task: @task }),
            turbo_stream.replace('modal', ''),
          ]
        end
        format.html { redirect_to tasks_path }
      else
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: "tasks/form", locals: { task: @task }) }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@task),
        ]
      end
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream
      end
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
