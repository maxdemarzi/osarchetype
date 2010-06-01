class CreateFuzzyTitles < ActiveRecord::Migration
  def self.up
    create_table "title_trigrams", :force => true do |t|
     t.integer "title_id"
     t.string  "token",   :null => false
    end
  end

  def self.down
    drop_table "title_trigrams"
  end
end
