class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :edit, :update, :destroy ]

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

    if @task.save
      respond_to do |format|
        format.turbo_stream do
          @tasks = current_user.tasks.reload
          render turbo_stream: [
            turbo_stream.update("tasks-container",
              partial: "tasks/task",
              collection: @tasks
            ),
            turbo_stream.remove("modal")
          ]
        end
      end
    else
      render :new, status: :unprocessable_entity
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
            turbo_stream.replace("task_#{@task.id}",
              partial: "tasks/task",
              locals: { task: @task }
            ),
            turbo_stream.remove("modal")
          ]
        end
        format.html { redirect_to tasks_path, notice: 'タスクが更新されました' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream {
          render :edit, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@task)
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
