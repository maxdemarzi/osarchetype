class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer    :user_id	
      t.string :name, :limit => 255
      t.string :email, :limit => 255

      t.timestamps
    end

	add_index :contacts, :name, :unique => false
	add_index :contacts, :email, :unique => false

  end

  def self.down
    drop_table :contacts
  end
end
