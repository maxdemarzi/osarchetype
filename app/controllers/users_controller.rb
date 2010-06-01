class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]


  def new  
    @user = User.new(:invitation_code => params[:invite_code])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end  
  
  def create  
   @user = User.new(params[:user])  
   @user.invite_not_needed = true

   if @user.save  
    flash[:notice] = "Registration successful."  
	profile = Profile.new
       profile.user_id = @user.id
       profile.save

	external_user = ExternalUser.find(:first, :conditions => "user_id IS NULL AND service = 'email' AND service_id = '#{@user.email}' ")
	if external_user.nil?
		external_user = ExternalUser.new 
		external_user.service = "email"
		external_user.service_id = @user.email
		external_user.service_handle = @user.username
	end
	external_user.user_id = @user.id
	external_user.save

    redirect_to root_url  
   else  
    render :action => 'new'  
   end  
  end  

  def edit  
    @user = current_user  
  end  
  
  def update  
    @user = current_user  
    if @user.update_attributes(params[:user])  
      flash[:notice] = "Successfully updated profile."  
      redirect_to root_url  
    else  
      render :action => 'edit'  
    end  
  end 

end
