class CreateExternalUsers < ActiveRecord::Migration
  def self.up
    create_table :external_users do |t|
      t.integer :user_id
      t.string :service
      t.string :service_id
      t.string :service_handle
      t.boolean :confirmed,     :default => 0, :null => false

      t.timestamps
    end

	add_index :external_users, :user_id, :unique => false
	add_index :external_users, :service_id, :unique => false
	add_index :external_users, :service_handle, :unique => false

  end

  def self.down
    drop_table :external_users
  end
end
