class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authenticate
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        password == "dash0salt"
      end
    end
  end
end
