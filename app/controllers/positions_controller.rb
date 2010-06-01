class PositionsController < ApplicationController
  before_filter :require_user

  # GET /positions
  # GET /positions.xml
  def index
    @positions = Position.find(:all, :conditions => {:user_id => current_user})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.xml
  def show
    @position = Position.find(:first, :conditions => {:id => params[:id], :user_id => current_user})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/new
  # GET /positions/new.xml
  def new
    @position = Position.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(:first, :conditions => {:id => params[:id], :user_id => current_user})
  end

  # POST /positions
  # POST /positions.xml
  def create
    @position = Position.new(params[:position])
    @position.user_id = current_user.id

    respond_to do |format|
      if @position.save
        flash[:notice] = 'Position was successfully created.'
        format.html { redirect_to(positions_url) }
        format.xml  { render :xml => @position, :status => :created, :location => @position }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
    @position = Position.find(:first, :conditions => {:id => params[:id], :user_id => current_user})

    respond_to do |format|
      if @position.update_attributes(params[:position])
        flash[:notice] = 'Position was successfully updated.'
        format.html { redirect_to(positions_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(:first, :conditions => {:id => params[:id], :user_id => current_user})
    @position.destroy

    respond_to do |format|
      flash[:notice] = 'Position was successfully deleted.'
      format.html { redirect_to(positions_url) }
      format.xml  { head :ok }
    end
  end
end
