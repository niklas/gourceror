require 'spec_helper'

describe Project do
  let(:project) { create(:project)}

  it "should not be visualizable without any source" do
    project.should_not be_visualizable
  end

  before do
    project.stub(:run_gource).and_return(true)
    project.stub(:pull).and_return(true)
  end

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

    it "should stop at the end" do
      args.should include('--stop-at-end')
    end

    it "should set title from name of project" do
      title = args.grep(/--title/).first
      title.should =~ /^--title '#{project.name}'/
    end

    it "should be visualizable" do
      project.should be_visualizable
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

  context "with multiple projects" do
    before :each do
      5.times { |i|  create :project, play_count: i+1, repository: 'git://github.com/anonymous/endless_loops' }
    end

    context 'next in queue' do
      subject { described_class.next_in_queue }
      it { should be_a(Project) }

      it "should have the lowest play count" do
        subject.play_count.should == 1
      end
    end
  end
end
