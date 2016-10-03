class ReportsController < ApplicationController

  def index
    @report = Report.new
  end

end
