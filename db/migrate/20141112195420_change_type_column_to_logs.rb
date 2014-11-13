class ChangeTypeColumnToLogs < ActiveRecord::Migration
  def change
    change_column :logs, :stack_trace, :text
  end
end
