class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|  
      t.integer :user_id
      t.string  :linkedin_id
      t.string  :first_name
      t.string  :last_name
      t.string  :headline
      t.string  :location
      t.string  :country_code
      t.string  :industry
      t.string  :summary 		, :limit => 2000 #long is 2000
      t.string  :specialties	, :limit => 500 #short is 500
      t.string  :proposal_comments , :limit => 500
      t.string  :associations      , :limit => 500
      t.string  :honors            , :limit => 500
      t.string  :picture_url	, :limit => 500
      t.string  :public_profile_url, :limit => 500
      t.timestamps
    end 
  end

  def self.down
    drop_table :profiles
  end
end
