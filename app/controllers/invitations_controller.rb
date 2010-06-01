class InvitationsController < ApplicationController
  before_filter :require_user

    def autocomplete_for_contact_email

      @items = Contact.find(:all, :conditions=>["email LIKE ? AND user_id = ?",'%'+params[:q].to_s.downcase + '%' , current_user.id], :limit => 15, :order => 'created_at DESC')

      out = if block_given?
        yield(@items)
      else
        %Q[<%= @items.map {|item| h(item.email)}.uniq.join("\n")%>]
      end
      render :inline => out
    end

  def new
	@invitation = Invitation.new
	@invitation.message = 'I set up a profile on Archety.pe where I can explore new career paths based on experience data from millions of professionals.  You can explore your opportunities by signing up.  It tales less than 1 minute.'
	@contacts = Contact.find(:all, :conditions=>["user_id = ?", current_user.id], :order => 'name').collect {|c| [ "#{c.name} - #{c.email}", c.email ] }
  end

  def create

    @recipients = Array.new
    @recipients << params[:invitation][:recipient_email].strip.split(',') unless params[:invitation][:recipient_email].nil?

    unless params[:invitation][:recipient_email_too].nil?
    	for r in params[:invitation][:recipient_email_too] do
		@recipients << r
	end
    end
    @recipients.uniq!

    @bademails = Array.new
    @goodemails = Array.new

    @recipients.each do |r|
	unless r.to_s.strip == ""  
	    @invitation = Invitation.new
	    @invitation.recipient_email = r.to_s.strip
	    @invitation.sender = current_user
	    @invitation.message = params[:invitation][:message]

	    if @invitation.save
		      #flash[:notice] = "Thank you, the invitation has been sent."
			@goodemails << @invitation.recipient_email
	    else
			@bademails << @invitation.recipient_email
		      #render :action => 'new' and return false
	    end
	end
    end

	if @bademails.empty?
		flash[:notice] = "Thank you, an invitation to #{@goodemails.join(',')} has been sent." unless @goodemails.empty?

	      redirect_to contacts_url
	else
		@invitation.recipient_email = @bademails.join(", ")
		@contacts = Contact.find(:all, :conditions=>["user_id = ?", current_user.id], :order => 'name').collect {|c| [ "#{c.name} - #{c.email}", c.email ] }
		render :action => 'new' and return false
	end
  end

end
