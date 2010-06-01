class User < ActiveRecord::Base
  acts_as_inviteable :default_invitation_limit => 20000
  acts_as_authentic  
  has_messages

  validates_presence_of :email
  validates_uniqueness_of :email

  has_one :google_token, :dependent=>:destroy #added for oauth services
  has_one :yahoo_token, :dependent=>:destroy #added for oauth services

  has_one :profile, :dependent=>:destroy
  has_many :educations
  has_many :positions
  has_many :contacts


  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

end
