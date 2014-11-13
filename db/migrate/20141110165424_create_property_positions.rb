class CreatePropertyPositions < ActiveRecord::Migration
  def change
    create_table :property_positions do |t|
      t.text :text
      t.integer :rating

      t.belongs_to :country
      t.belongs_to :property_name

      t.timestamps
    end

    add_index :property_positions, :rating

  end
end
