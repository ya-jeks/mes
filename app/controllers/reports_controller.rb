class ReportsController < ApplicationController
  before_filter :set_dates, only: :index

  def index
    @report = Report.new @start_date, @end_date
  end

  private
  def set_dates
    @start_date = (params[:start_date] || Date.today.to_s)
    @end_date = (params[:end_date] || Date.today.to_s)
  end

end
