class ReportsController < ApplicationController

  def index
    @report = Report.new start_date, end_date
  end

  private
  def start_date
    params[:start_date] || Date.today.to_s
  end

  def end_date
    params[:end_date] || Date.today.to_s
  end

end
