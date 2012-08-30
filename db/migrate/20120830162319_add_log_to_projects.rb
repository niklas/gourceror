class AddLogToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :log, :string
  end
end
