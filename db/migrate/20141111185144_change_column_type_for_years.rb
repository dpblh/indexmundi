class ChangeColumnTypeForYears < ActiveRecord::Migration
  def change
    add_column :years, :value, :float
  end
end
