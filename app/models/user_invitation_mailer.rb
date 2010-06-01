class UserInvitationMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  sendgrid_enable   :ganalytics, :opentracking
  
  def invitation(invite)
    subject    "You've been sent an invitation to try out Archety.pe"
    recipients invite.recipient_email
    from       invite.sender.email
    sent_on    Time.current
    body       :invite => invite
  end

end
