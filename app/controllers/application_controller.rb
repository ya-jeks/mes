class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include Pundit

  protect_from_forgery with: :null_session
  before_action :set_meta, :force_session

  rescue_from ActionView::MissingTemplate do |e|
    render file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
  end

  protected
    include SessionCallbacks
    def set_meta
      @title = ['']
      @keywords = ['']
      @description = ['']
    end

end
