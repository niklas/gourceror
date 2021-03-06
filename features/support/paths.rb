module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the (?:home|list) page$/
      '/'

    when 'the admin dashboard'
      admin_dashboard_path

    when /^the edit page (?:of|for) #{capture_model}$/
      case m = model!($1)
      when Project
        edit_project_path(m)
      else
        flunk "Can't find mapping for page of #{$1}" +
          "Now, go and add a mapping in #{__FILE__}"
      end

    when /^the page (?:of|for) #{capture_model}$/
      case m = model!($1)
      when Project
        project_path(m)
      else
        flunk "Can't find mapping for page of #{$1}" +
          "Now, go and add a mapping in #{__FILE__}"
      end

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
