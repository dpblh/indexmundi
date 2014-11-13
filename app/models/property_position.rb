class PropertyPosition < ActiveRecord::Base
  belongs_to :country
  belongs_to :property_name
  has_many :graph_positions

  scope :only_text, -> { where.not(text: nil) }
  scope :translate, -> { where(translate: true) }
  scope :untranslate, -> { where(translate: false) }
end
