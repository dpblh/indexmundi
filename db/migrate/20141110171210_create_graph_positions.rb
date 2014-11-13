class CreateGraphPositions < ActiveRecord::Migration
  def change
    create_table :graph_positions do |t|
      t.integer :value

      t.belongs_to :property_position
      t.belongs_to :year

      t.timestamps
    end

    add_index :graph_positions, :value

  end
end
