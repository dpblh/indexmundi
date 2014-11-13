class GraphPosition < ActiveRecord::Base
  belongs_to :property_position
  belongs_to :year
end
