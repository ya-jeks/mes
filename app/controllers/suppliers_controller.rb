class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = current_user.suppliers.page params[:page]
  end

  def new
    @supplier = current_user.suppliers.build
  end

  def create
    @supplier = Supplier.new supplier_params
    @supplier.users << current_user

    if @supplier.save
      redirect_to (params[:modal].present? ? :back : suppliers_path), notice: 'Добавлено'
    else
      render :new
    end
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: 'Сохранено'
    else
      render :edit
    end
  end

  def destroy
    @supplier.destroy
    render text: 'Удалено'
  rescue ActiveRecord::InvalidForeignKey => e
    Rails.logger.error "#{e.message}, #{e.backtrace.first(2)}"
    render text: 'Адрес нельзя убрать т.к. он уже используется'
  end

  private
    def set_supplier
      @supplier = current_user.suppliers.find(params[:id])
    end

    def supplier_params
      params[:supplier].permit(:id, :code, :address, :capacity)
    end
end
