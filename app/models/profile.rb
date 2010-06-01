class Profile < ActiveRecord::Base

	belongs_to :user

	validates_length_of :first_name        , :allow_nil => true , :maximum => 255  
	validates_length_of :last_name         , :allow_nil => true , :maximum => 255  
	validates_length_of :headline          , :allow_nil => true , :maximum => 255  
	validates_length_of :location          , :allow_nil => true , :maximum => 255  
	validates_length_of :country_code      , :allow_nil => true , :maximum => 255  
	validates_length_of :industry          , :allow_nil => true , :maximum => 255  
	validates_length_of :summary           , :allow_nil => true , :maximum => 200  
	validates_length_of :specialties       , :allow_nil => true , :maximum => 500  
	validates_length_of :proposal_comments , :allow_nil => true , :maximum => 500
	validates_length_of :associations      , :allow_nil => true , :maximum => 500
	validates_length_of :honors            , :allow_nil => true , :maximum => 500
	validates_length_of :picture_url       , :allow_nil => true , :maximum => 500
	validates_length_of :public_profile_url, :allow_nil => true , :maximum => 500


	validates_presence_of :user_id


	define_index do
	     # following fields are database fields
	     # we can not add model methods in sphinx index 
	     # sphinx fields allows ONLY model based associations
	     # fields
	      indexes first_name
	      indexes last_name
	      indexes headline
	      indexes location
	      indexes industry
	      indexes summary
	      indexes specialties
	      indexes proposal_comments
	      indexes associations
	      indexes honors
	      indexes public_profile_url
	end

end
