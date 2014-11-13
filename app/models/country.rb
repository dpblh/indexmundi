class Country < ActiveRecord::Base
  has_many :property_positions

  scope :translate, -> { where(translate: true) }
  scope :untranslate, -> { where(translate: false) }


  class << self

    def hash_category_places(country)
      pps = where(id: country.id).includes(property_positions: [property_name: [:category], graph_positions: [:year]])
      hash = {}
      if pps.first
        pps.first.property_positions.each { |pp|
          category_name = pp.property_name.category.name
          if hash[category_name]
            hash[category_name] << pp
          else
            hash[category_name] = [pp]
          end
        }
      end
      hash
    end

  end

end
