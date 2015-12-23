class TasksController < ApplicationController
  before_action :set_task, :auth_task, only: [:show, :destroy, :finish, :deliver]

  def show
  end

  def index
    @supplier = supplier || current_user.sales_supplier
    @tasks = Task.accessible_to_view_by(current_user).
      by_supplier(@supplier).
      order('state desc, sku_id, created_at desc').
      page(params[:page])
  end

  def finish
    @task.finish!
    redirect_to :back
  end

  def deliver
    @task.deliver!
    redirect_to :back
  end

  def accept
    @task = Task.accessible_to_accept_by(current_user).find(params[:id])
    auth_task

    @task.accept!
    redirect_to :back
  end

  def reject
    @task = Task.accessible_to_accept_by(current_user).find(params[:id])
    auth_task

    @task.reject!
    redirect_to :back
  end

  def destroy
    @task.destroy
    redirect_to :back
  end

  private
    def set_task
      @task = Task.accessible_to_view_by(current_user).find(params[:id])
    end

    def auth_task
      authorize @task
    end

    def supplier
      @supplier ||= current_user.suppliers.find_by_id(params[:supplier_id])
    end

    def task_params
      params[:task].permit(:supplier_id)
    end

end