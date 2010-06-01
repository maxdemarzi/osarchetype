class Contact < ActiveRecord::Base
  belongs_to :user
  named_scope :by_user,
      lambda { |user_id| {
        :conditions => [ "users.id = ?", user_id ]
      } }
end
