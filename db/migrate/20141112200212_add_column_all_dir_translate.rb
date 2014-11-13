class AddColumnAllDirTranslate < ActiveRecord::Migration
  def change
    add_column :countries, :translate, :boolean, default: false
    add_column :property_names, :translate, :boolean, default: false
    add_column :categories, :translate, :boolean, default: false
    add_column :property_positions, :translate, :boolean, default: false
    add_column :property_positions, :rus_text, :text
  end
end
