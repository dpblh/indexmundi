class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :level
      t.string :text
      t.string :stack_trace

      t.timestamps
    end
  end
end
