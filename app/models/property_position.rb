class PropertyPosition < ActiveRecord::Base
  belongs_to :country
  belongs_to :property_name
  has_many :graph_positions
end
