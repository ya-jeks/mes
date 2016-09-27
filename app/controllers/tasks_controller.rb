class TasksController < ApplicationController
  before_action :set_task, :auth_task, only: [:show, :destroy, :finish, :deliver]
  before_action :set_sku, only: [:create]

  def create
    @task = Task.new user: current_user,
                     sku: @sku,
                     supplier: Supplier.find(task_params[:supplier_id]),
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
    @q = Task.search params[:q]
    @tasks = @q.result.
      accessible_to_view_by(current_user).
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

  def mass_destroy
    @tasks = Task.where(id: params[:task_ids]).initialized
    @tasks.destroy_all
    redirect_to :back
  end

  def process_state
    t = Task.find(params[:id])
    if t.may_finish?
      t.finish!
    elsif t.may_deliver?
      t.deliver!
    elsif t.may_accept?
      t.accept!
    else
      t
    end
    Redis.current.publish("users.#{t.user_id}", {action: :update, task: t.as_json}.to_json)
    render json: {ok: true}, status: 200
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Not found'}, status: 404
  rescue AASM::InvalidTransition
    render json: {error: t.errors.messages}, status: 422
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

    def task_params
      params[:task].permit(:supplier_id, :sku_id, :qty)
    end

end
