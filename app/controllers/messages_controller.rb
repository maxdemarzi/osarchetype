class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    @messages 	= current_user.received_messages
    @sent_messages   = current_user.sent_messages
    @drafts 		= current_user.unsent_messages

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = current_user.messages.build
    @action = "New"

    if !params[:perform].nil?
      @existing_message = Message.find(params[:id]) unless params[:id].nil?
      @message.subject = @existing_message.subject 
      @message.body = @existing_message.body

      if (params[:perform] == "forward")
        @action = "Forwarding"
      end

      if (params[:perform] == "reply")
        @action = "Replying to"
        @message.to @existing_message.sender
      end

      if (params[:perform] == "reply_to_all")
        @action = "Replying to All"
        @message.to @existing_message.sender, @existing_message.recipients.to_a.collect{|recipient| recipient.receiver}
      end
   end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create

    @message = current_user.messages.build
    @message.subject = params[:message][:subject]
    @message.body = params[:message][:body]
#    @message.to User.find_by_username(params[:message][:to])
    @message.to User.find(:all, :conditions=>["username IN (\"#{params[:message][:to].split(',').join("\",\"")}\")"  ]) unless params[:message][:to].nil?


    respond_to do |format|
      if @message.save
        @message.deliver

        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
