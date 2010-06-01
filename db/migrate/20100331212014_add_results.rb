class AddResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|  
      t.integer :row_number
      t.integer :job_id
      t.string  :title
      t.integer :next_id
      t.string  :next_title
      t.integer :thecount
      t.float :thepct
    end 
  end

  def self.down
	drop_table :results
  end
end
