class ProfilesController < ApplicationController
  before_filter :require_user,  :only => [:edit, :update]

  # GET /profiles/1
  # GET /profiles/1.xml
  def show

    username = params[:username]

	@user = User.find_by_username(username)
	if @user
		@title = "Profile for #{username}"
	       @profile = @user.profile 
		@positions = Array.new
		@educations = Array.new
		@positions = @user.positions unless @user.positions.nil?
		@educations = @user.educations unless @user.educations.nil?


		respond_to do |format|
			format.html # show.html.erb
		       format.xml  { render :xml => @profile }
		end
	else
		flash[:error] = "No user #{username} found!"
		redirect_to :action => "index"
	end



  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find_by_user_id(current_user)
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = Profile.find_by_user_id(current_user)

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to(@profile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

end
