class ProjectsController < InheritedResources::Base

  def create
    create! { edit_project_path(resource) }
  end

  def update
    update! { projects_path }
  end

  def push
    resource.push!
    redirect_to resource
  end

end
