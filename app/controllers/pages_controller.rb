class PagesController < ApplicationController
  def about
	@title = "About"
  end

  def home
	@title = "Home"
  end

  def help
	@title = "Help"
  end

  def terms
	@title = "Terms of Service"
  end

  def privacy
	@title = "Privacy Policy"
  end

  def press
	@title = "Press"
  end

  def suggestions
	@searchterm = Position.find(:first, :conditions => {:user_id => current_user}).try(:title)
	@position = Position.find(:first, :conditions => {:user_id => current_user}).try(:title)

	look = Title.find(:first, :conditions => {:title => @position}) 
	@found = look.title unless look.nil?
	if @found
		@position = look
	else
		@position = Title.fuzzy_find(@position).first
	end

	@results = Result.find(:all, :conditions => {:job_id => @position.try(:id)}, :limit => 10, :order => "thepct DESC")
  end

  def jobs
      @title = params[:what]
      @jobs = Rindeed.paginate(@title, params[:where], :page => params[:page] || 1)
  end

  def people

	if current_user.linkedin_token
		client = LinkedIn::Client.new("I2th0A2lzqudCrCKfhYM25oBVdAc9GkyqWG4zFwEKAzSUp73fpZfAC0Lufl7eLMr", "ZXS-Dd3IayXpXW5dY8IBPp5hm2gGqoLvwEbNvhSg7FQLIHiddiFF-bTObr_VlEyc")
		client.authorize_from_access(current_user.linkedin_token, current_user.linkedin_secret)
		@title = params[:title]
		@peers = client.search( :title => @title, :current_title => "true", :search_location_type => 'I').profiles
	end
  end

end
