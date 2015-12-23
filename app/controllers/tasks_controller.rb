class TasksController < ApplicationController
  before_action :set_task, :auth_task, only: [:show, :destroy, :finish, :deliver]
  before_action :set_supplier, :set_sku, only: [:create]

  def show
  end

  def create
    @task = Task.new user: current_user,
                     sku: @sku,
                     supplier: @supplier,
                     qty: task_params[:qty],
                     due_date: Time.current,
                     price: task_params[:qty].to_f * @sku.price_on(current_user.sales_dep)

    @task.build_props_from(sess.chosen_props)

    if @task.save
      redirect_to tasks_path
    else
      redirect_to :back, alert: @task.errors.messages
    end
  end

  def index
    @supplier = Supplier.find_by_id(params[:supplier_id]) || current_user.sales_dep

    @tasks = Task.accessible_to_view_by(current_user).
      by_supplier(@supplier).page(params[:page])
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

    def set_sku
      @sku = Sku.find(task_params[:sku_id])
    end

    def set_supplier
      @supplier ||= current_user.suppliers.find_by_id(task_params[:supplier_id]) || current_user.sales_dep
    end

    def task_params
      params[:task].permit(:supplier_id, :sku_id, :qty)
    end

end
