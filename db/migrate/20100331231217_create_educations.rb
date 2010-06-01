class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|  
      t.integer :user_id
      t.string  :linkedin_id
      t.string  :school_name
      t.string  :degree
      t.string  :field_of_study
      t.string  :activities		, :limit => 500
      t.integer :start_year
      t.integer :start_month
      t.integer :end_year
      t.integer :end_month
      t.timestamps
    end 
  end

  def self.down
    drop_table :educations
  end
end
