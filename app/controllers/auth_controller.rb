require 'rubygems'
require 'linkedin'

class AuthController < ApplicationController

  def index
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new('yourAPIKey', 'yourSecretKey')
    request_token = client.request_token(:oauth_callback => 
                                      "http://#{request.host_with_port}/auth/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url

  end

  def callback
     client = LinkedIn::Client.new('yourAPIKey', 'yourSecretKey')
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
      @user = current_user
      @user.linkedin_token = atoken
      @user.linkedin_secret = asecret
      @user.save

    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = client.profile
    @profile = client.profile(:fields => [:id, :first_name, :last_name, :headline, :location, :industry, :num_recommenders, :summary, :specialties,  :proposal_comments, :associations, :honors, :positions, :educations, :member_url_resources, :picture_url, :public_profile_url ])
    #@peers = client.search( :title => @profile.positions.first.title, :current_title => "true", :search_location_type => 'I').profiles	
    @peers = nil

    @connections = client.connections

	@linkedin_profile = Profile.find_by_user_id(current_user)
	if @linkedin_profile.nil? 
		@linkedin_profile = Profile.new
	end

	@linkedin_profile.user_id = current_user.id
	@linkedin_profile.linkedin_id        = @profile.id
	@linkedin_profile.first_name         = @profile.first_name
	@linkedin_profile.last_name          = @profile.last_name
	@linkedin_profile.headline           = @profile.headline
	@linkedin_profile.location           = @profile.location.name
	@linkedin_profile.country_code       = @profile.location.country["country"]
	@linkedin_profile.industry           = @profile.industry
	@linkedin_profile.summary            = @profile.summary
	@linkedin_profile.specialties        = @profile.specialties
	@linkedin_profile.proposal_comments  = @profile.proposal_comments
	@linkedin_profile.associations       = @profile.associations
	@linkedin_profile.honors             = @profile.honors
	@linkedin_profile.picture_url        = @profile.picture_url
#	@linkedin_profile.public_profile_url = @profile.site_standard_profile_request
	@linkedin_profile.public_profile_url = @profile.public_profile_url


      if @linkedin_profile.save
        flash[:notice] = 'Profile was successfully updated.'
      else
        flash[:error] = 'There was a problem importing your Profile.'
      end

# for Each position... delete them all and re-import them.

	linkedin_positions = Position.find(:all, :conditions => {:user_id => current_user})
	unless linkedin_positions.nil?
		linkedin_positions.each {|x| x.destroy }
	end


	unless @profile.positions.empty?
		@profile.positions.each do |pos|
			linked_in_position = Position.new
			linked_in_position.user_id     = current_user.id
			linked_in_position.linkedin_id = pos.id
			linked_in_position.title       = pos.title
			linked_in_position.summary     = pos.summary
			linked_in_position.start_year  = pos.start_year
			linked_in_position.start_month = pos.start_month
			linked_in_position.end_year    = pos.end_year
			linked_in_position.end_month   = pos.end_month
			linked_in_position.is_current  = pos.is_current
			linked_in_position.company     = pos.company.name
		      if linked_in_position.save
		        flash[:notice] = 'Position was successfully updated.'
		      else
		        flash[:error] = 'There was a problem importing your Position.'
		      end
		end
	end



# for Each education... delete them all and re-import them.

	linkedin_educations = Education.find(:all, :conditions => {:user_id => current_user})
	unless linkedin_educations.nil?
		linkedin_educations.each {|x| x.destroy }
	end


	unless @profile.education.empty?
		@profile.education.each do |edu|
			linked_in_education = Education.new
			linked_in_education.user_id     = current_user.id
			linked_in_education.linkedin_id = edu.id
			linked_in_education.school_name = edu.school_name
			linked_in_education.degree      = edu.degree
			linked_in_education.field_of_study      = edu.field_of_study
			linked_in_education.activities      = edu.activities
			linked_in_education.start_year  = edu.start_year
			linked_in_education.start_month = edu.start_month
			linked_in_education.end_year    = edu.end_year
			linked_in_education.end_month   = edu.end_month
		      if linked_in_education.save
		        flash[:notice] = 'Education was successfully updated.'
		      else
		        flash[:error] = 'There was a problem importing your Education.'
		      end
		end
	end
	


  end
end