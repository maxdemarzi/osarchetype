class Invitation < ActiveRecord::Base
  acts_as_invitation :user_class_name => 'User'

  attr_accessor :recipient_email_too

end
