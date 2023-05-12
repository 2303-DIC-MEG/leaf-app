class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = current_user.tasks
    if params[:sort_expired_at]
      @tasks = @tasks.all.sort_expired_at
    elsif params[:sort_priority]
      @tasks = @tasks.all.sort_priority
    elsif  
      @tasks = @tasks.all.order(created_at: :desc)
    end

    #あいまい検索機能
    if params[:task].present?
      title = params[:task][:title]
      status = params[:task][:status]
      label_id = params[:task][:label_id]
    
      @tasks = @tasks.title_search(title) if title.present?
      @tasks = @tasks.status_search(status) if status.present?
      @tasks = @tasks.label_search(label_id) if title.blank? && status.blank? && label_id.present?
    end 
    # if params[:task].present?
    #   title = params[:task][:title]
    #   status = params[:task][:status]
    #   label_id = params[:task][:label_id]
    #   if title.present? && status.present?
    #     @tasks = @tasks.title_search(title).status_search(status)
    #   elsif title.present? && status.blank?
    #     @tasks = @tasks.title_search(title)
    #   elsif status.present?
    #     @tasks = @tasks.status_search(status)
    #   elsif title.blank? && status.blank? && label_id.present?
    #     @tasks = @tasks.label_search(label_id)
    #   end
    # end
    @tasks = @tasks.page(params[:page]).per(8)
  end  

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)

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
    params.require(:task).permit(:title, :content, :expired_at, :status, :priority, { label_ids: [] })
  end
end
