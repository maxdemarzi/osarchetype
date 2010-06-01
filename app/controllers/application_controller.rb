# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :mailer_set_url_options

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


  Rindeed.publisher_id = "yourpublisherid"
  Rindeed.default_options(:chnl => "beta", :limit => 30)


 helper_method :current_user  
  
 private  
  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find  
  end  
  
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end 


  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

     def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_url
        return false
      end
    end
    
    def store_location
	if request.request_method == :get and !request.xhr?
	   session[:return_to] = request.request_uri
	end
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

   def login_required
	require_user
   end 


   def mailer_set_url_options
     ActionMailer::Base.default_url_options[:host] = request.host_with_port
   end

end
