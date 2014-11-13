class CreatePropertyNames < ActiveRecord::Migration
  def change
    create_table :property_names do |t|
      t.string :name
      t.string :rus_name

      t.belongs_to :category

      t.timestamps
    end
  end
end
