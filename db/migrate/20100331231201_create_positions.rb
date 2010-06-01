class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|  
      t.integer :user_id
      t.string  :linkedin_id
      t.string  :title
      t.string  :summary
      t.integer :start_year
      t.integer :start_month
      t.integer :end_year
      t.integer :end_month
      t.string  :is_current
      t.string  :company
      t.timestamps
    end 

  end

  def self.down 
    drop_table :positions
  end
end
