class EducationsController < ApplicationController
  before_filter :require_user

  # GET /educations
  # GET /educations.xml
  def index
    @educations = Education.find(:all, :conditions => {:user_id => current_user.id})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @educations }
    end
  end

  # GET /educations/1
  # GET /educations/1.xml
  def show
    @education = Education.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @education }
    end
  end

  # GET /educations/new
  # GET /educations/new.xml
  def new
    @education = Education.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @education }
    end
  end

  # GET /educations/1/edit
  def edit
    @education = Education.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})
  end

  # POST /educations
  # POST /educations.xml
  def create
    @education = Education.new(params[:education])
    @education.user_id = current_user.id

    respond_to do |format|
      if @education.save
        flash[:notice] = 'Education was successfully created.'
        format.html { redirect_to(educations_url) }
        format.xml  { render :xml => @education, :status => :created, :location => @education }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @education.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /educations/1
  # PUT /educations/1.xml
  def update
    @education = Education.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})

    respond_to do |format|
      if @education.update_attributes(params[:education])
        flash[:notice] = 'Education was successfully updated.'
        format.html { redirect_to(educations_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @education.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /educations/1
  # DELETE /educations/1.xml
  def destroy
    @education = Education.find(:first, :conditions => {:id => params[:id], :user_id => current_user.id})
    @education.destroy

    respond_to do |format|
      flash[:notice] = 'Education was successfully deleted.'
      format.html { redirect_to(educations_url) }
      format.xml  { head :ok }
    end
  end
end
