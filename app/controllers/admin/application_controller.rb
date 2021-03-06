require 'bcrypt'

class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'admin'
  before_filter :authenticate
  before_filter :save_back_url, :only => [:new, :edit]

  protected
   def authenticate
     unless ENV["RAILS_ENV"] == 'test'
      authenticate_or_request_with_http_basic do |username, password|
        username == AdminSettings.admin_login && BCrypt::Password.new(AdminSettings.admin_password) == password
      end
     end
   end

   def save_back_url
     session[:back_url] = request.referer
   end
end
