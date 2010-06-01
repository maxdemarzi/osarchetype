class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :token, :null => false
      t.string :recipient_email, :null => false
      t.string :message, :limit => 5000

      t.timestamps
    end
    add_column :users, :invitation_limit, :integer, :default => 20000
    add_index :invitations, :sender_id
    add_index :invitations, :recipient_email, :unique => false
    add_index :invitations, :token, :unique => true
  end

  def self.down
    remove_index :invitations, :column => :sender_id
    remove_index :invitations, :column => :recipient_email
    remove_index :invitations, :column => :token
    remove_column :users, :invitation_sent_count
    drop_table :invitations
  end
end
