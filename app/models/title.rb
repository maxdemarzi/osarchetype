class Title < ActiveRecord::Base
  include FuzzySearch
  fuzzy_search_attributes :title

end
