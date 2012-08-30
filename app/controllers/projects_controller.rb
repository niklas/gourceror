class ProjectsController < InheritedResources::Base

  def create
    create! { edit_project_path(resource) }
  end

  def update
    update! { projects_path }
  end

end
