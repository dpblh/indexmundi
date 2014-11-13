class ChangeColunNameToPropertyPosition < ActiveRecord::Migration
  def change
    rename_column :property_positions, :rus_text, :rus_name
  end
end
