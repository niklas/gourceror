class AddPlayCountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :play_count, :integer
  end
end
