require 'spec_helper'

describe Project do
  let(:project) { create(:project)}

  shared_examples 'project counting plays' do
    it "should increase play_count by 1" do
      expect { project.play! }.to change(project, :play_count).by(1)
    end
  end

  shared_examples 'visualizable project' do
    let(:args) { project.gource_arguments }
    it "should not fade files" do
      args.should include('--file-idle-time 0')
    end

    it "should run in the specified resolution" do
      Project.resolution = '1920x1080'
      args.should include('-1920x1080')
    end

    it "should run in fullscreen" do
      args.should include('-f')
    end

    it "should set title from name of project" do
      args.should include("--title '#{project.name}'")
    end
  end

  context "with repo url" do
    let(:repository_url) { 'git://github.com/anonymous/endless_loops'} 
    let(:project) { create(:project, repository: repository_url) }

    it_should_behave_like 'project counting plays'
    it_should_behave_like 'visualizable project'
  end

  context "with uploaded log" do
    let(:project) { create(:project, log: File.open('spec/fixtures/history.log') ) }
    it_should_behave_like 'project counting plays'
    it_should_behave_like 'visualizable project'

    it "should have the log file as last item of command line" do
      project.gource_arguments.last.should =~ %r~/history.log$~
    end
  end
end
