class AddColumnToPropertyNames < ActiveRecord::Migration
  def change
    add_column :property_names, :value_from_table, :string
  end
end
