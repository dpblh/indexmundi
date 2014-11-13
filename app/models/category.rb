class Category < ActiveRecord::Base
  has_many :property_names

  scope :translate, -> { where(translate: true) }
  scope :untranslate, -> { where(translate: false) }

end
