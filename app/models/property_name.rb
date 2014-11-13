class PropertyName < ActiveRecord::Base
  has_many :property_positions
  belongs_to :category

  scope :only_table, -> { where.not(value_from_table: nil) }
  scope :translate, -> { where(translate: true) }
  scope :untranslate, -> { where(translate: false) }

end
