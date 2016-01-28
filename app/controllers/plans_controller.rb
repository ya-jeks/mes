class PlansController < ApplicationController

  def index
    @plans = Plan.all.page params[:page]
  end

  def new
    @plan = Plan.new(task_ids: params[:task_ids])
  end

  def create
    @plan = Plan.new user_id: current_user.id,
                     task_ids: params[:task_ids]

    if @plan.save
      redirect_to plans_path, notice: 'Plan created'
    else
      render :new, notice: @plan.errors.messages
    end
  end

end
