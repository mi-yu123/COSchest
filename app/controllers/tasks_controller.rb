class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def index
    @tasks = current_user.tasks.order(completed: :asc, due_date: :asc)
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
            turbo_stream.update('flash', partial: 'shared/flash', locals: { message: 'タスクを作成しました', type: 'success' })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('modal', partial: 'tasks/form', locals: { task: @task }),
            turbo_stream.update('flash', partial: 'shared/flash', locals: { message: 'タスクの作成に失敗しました', type: 'error' })
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
            turbo_stream.update('flash', partial: 'shared/flash', locals: { message: 'タスクを更新しました', type: 'success' })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('modal', partial: 'tasks/form', locals: { task: @task }),
            turbo_stream.update('flash', partial: 'shared/flash', locals: { message: 'タスクの更新に失敗しました', type: 'error' })
          ]
        end
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@task),
          turbo_stream.update('flash', partial: 'shared/flash', locals: { message: 'タスクを削除しました', type: 'success' })
        ]
      end
    end
  end

  def toggle
    @task.update(completed: !@task.completed)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(@task, partial: 'tasks/task', locals: { task: @task }),
          turbo_stream.update('flash', partial: 'shared/flash', 
            locals: { 
              message: @task.completed ? 'タスクを完了しました' : 'タスクを未完了に戻しました',
              type: 'success'
            }
          )
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
        render turbo_stream: turbo_stream.update('flash', 
          partial: 'shared/flash',
          locals: { message: '指定されたタスクが見つかりません', type: 'error' }
        )
      end
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
