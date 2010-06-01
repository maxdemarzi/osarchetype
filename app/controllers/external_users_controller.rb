class ExternalUsersController < ApplicationController
  # GET /external_users
  # GET /external_users.xml
  def index
    @external_users = ExternalUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @external_users }
    end
  end

  # GET /external_users/1
  # GET /external_users/1.xml
  def show
    @external_user = ExternalUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @external_user }
    end
  end

  # GET /external_users/new
  # GET /external_users/new.xml
  def new
    @external_user = ExternalUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @external_user }
    end
  end

  # GET /external_users/1/edit
  def edit
    @external_user = ExternalUser.find(params[:id])
  end

  # POST /external_users
  # POST /external_users.xml
  def create
    @external_user = ExternalUser.new(params[:external_user])

    respond_to do |format|
      if @external_user.save
        flash[:notice] = 'ExternalUser was successfully created.'
        format.html { redirect_to(@external_user) }
        format.xml  { render :xml => @external_user, :status => :created, :location => @external_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @external_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /external_users/1
  # PUT /external_users/1.xml
  def update
    @external_user = ExternalUser.find(params[:id])

    respond_to do |format|
      if @external_user.update_attributes(params[:external_user])
        flash[:notice] = 'ExternalUser was successfully updated.'
        format.html { redirect_to(@external_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @external_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /external_users/1
  # DELETE /external_users/1.xml
  def destroy
    @external_user = ExternalUser.find(params[:id])
    @external_user.destroy

    respond_to do |format|
      format.html { redirect_to(external_users_url) }
      format.xml  { head :ok }
    end
  end
end
