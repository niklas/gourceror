class AddRepositoryToProject < ActiveRecord::Migration
  def change
    add_column :projects, :repository, :string
  end
end
