class AddColumnTocountries < ActiveRecord::Migration
  def change
    add_column :countries, :value_from_table, :string
    add_column :countries, :value_from_compare, :string
  end
end
