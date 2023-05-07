class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = Task.all
    if params[:sort_expired_at]
      @tasks = @tasks.all.sort_expired_at.page(params[:page])
    elsif params[:sort_priority]
      @tasks = @tasks.all.sort_priority.page(params[:page])
    elsif  
      @tasks = @tasks.all.order(created_at: :desc)
    end
    if params[:title].present? && params[:status].present?
      @tasks = @tasks.where('title LIKE ?', "%#{params[:title]}%").where('status LIKE ?', "%#{params[:status]}%")
    elsif params[:title].present?
      @tasks = @tasks.where('title LIKE ?', "%#{params[:title]}%")
    elsif params[:status].present?
      @tasks = @tasks.where('status LIKE ?', "%#{params[:status]}%")
    end 
  end
  

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :expired_at, :status, :priority)
    end
end
