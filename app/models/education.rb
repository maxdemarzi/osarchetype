class Education < ActiveRecord::Base
	belongs_to :user

	validates_numericality_of :start_year  , :allow_nil => true , :only_integer => true, :less_than_or_equal_to => Time.now.strftime('%Y').to_i, :greater_than_or_equal_to => 1900
	validates_numericality_of :end_year    , :allow_nil => true , :only_integer => true, :less_than_or_equal_to => Time.now.strftime('%Y').to_i, :greater_than_or_equal_to => 1900
	validates_numericality_of :start_month , :allow_nil => true , :only_integer => true, :less_than_or_equal_to => 12, :greater_than_or_equal_to => 1
	validates_numericality_of :end_month   , :allow_nil => true , :only_integer => true, :less_than_or_equal_to => 12, :greater_than_or_equal_to => 1

	validates_length_of :school_name       , :allow_nil => true , :maximum => 255  
	validates_length_of :degree            , :allow_nil => true , :maximum => 255  
	validates_length_of :field_of_study    , :allow_nil => true , :maximum => 255  
	validates_length_of :activities        , :allow_nil => true , :maximum => 500  

	validates_presence_of :user_id
end
