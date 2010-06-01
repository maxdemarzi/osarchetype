class ContactsController < ApplicationController
   before_filter :require_user

  # GET /contacts
  # GET /contacts.xml
  def index
    #@contacts = Contact.find_all_by_user_id(current_user)
    @contacts = Contact.paginate_by_user_id(current_user, :page => params[:page] || 1, :per_page => 10, :order => 'name')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    @consumer_tokens=ConsumerToken.all :conditions=>{:user_id=>current_user.id}
    @services=OAUTH_CREDENTIALS.keys-@consumer_tokens.collect{|c| c.class.service_name}

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(:first, :conditions => {:id => params[:id], :user_id => current_user})

  end

 # GET /contacs/import

  def import
	@new_contacts = Array.new
	@existing_contacts = Contact.find_all_by_user_id(current_user.id)

    case params[:type]
    when "Google"
	@google_token = GoogleToken.find_by_user_id current_user.id
	@client = @google_token.portable_contacts 
	@imported_contacts = @client.all

	for import in @imported_contacts
		found = false

		@existing_contacts.each do |existing|
			if existing.email.to_s == import.email.to_s
				found = true
			end
		end

		#skip subscribe and unsubscribe
		if (import.email.include? "subscribe" ) || (import.email.include? "googlegroups.com")
			found = true
		end

		if found == false
			newcontact = Contact.new(:user_id => current_user.id	, :name => import.display_name, :email => import.email)
			newcontact.save
			@new_contacts << newcontact

			external_user = ExternalUser.find(:first, :conditions => "user_id IS NULL AND service = 'email' AND service_id = '#{import.email}' ")
			if external_user.nil?
				external_user = ExternalUser.new 
				external_user.service = "email"
				external_user.service_id = import.email
				external_user.service_handle = import.display_name
				external_user.save
			end
		end
	end
	#redirect_to(contacts_url)

    when "Yahoo"
	@yahoo_token = YahooToken.find_by_user_id current_user.id
	@client = @yahoo_token.social_api 
	@imported_contacts = @client.contacts

	#Debug
	puts @imported_contacts.inspect

	for import in @imported_contacts["contacts"]["contact"]
		found = false
		name = ""

		for field in import["fields"]
			if field["type"] == "name"
				name = name + field["value"]["givenName"] unless field["value"]["givenName"].nil?
				name = name + " " + field["value"]["middleName"] unless field["value"]["middleName"].nil?
				name = name + " " + field["value"]["familyName"] unless field["value"]["familyName"].nil?
			end
			if field["type"] == "email"
				email = field["value"] 
			end
		end


		@existing_contacts.each do |existing|
			if existing.email.to_s == email.to_s
				found = true
			end
		end


		#skip subscribe and unsubscribe
		if (email.nil?) || (email.include? "subscribe" ) || (email.include? "googlegroups.com")
			found = true
		end

		if found == false
			newcontact = Contact.new(:user_id => current_user.id, :name => name, :email => email)
			newcontact.save
			@new_contacts << newcontact

			external_user = ExternalUser.find(:first, :conditions => "user_id IS NULL AND service = 'email' AND service_id = '#{email}' ")
			if external_user.nil?
				external_user = ExternalUser.new 
				external_user.service = "email"
				external_user.service_id = email
				external_user.service_handle = name
				external_user.save
			end
		end
	end

    end




  end


  # POST /contacts
  # POST /contacts.xml
  def create

    @contact = Contact.new(params[:contact])
    @contact.user_id = current_user.id

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(@contact) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(:first, :conditions => {:id => params[:id], :user_id => current_user})

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(@contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Contact.find(:first, :conditions => {:id => params[:id], :user_id => current_user})
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
end
