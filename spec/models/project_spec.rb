require 'spec_helper'

describe Project do
  let(:project) { create(:project)}

  shared_examples 'project counting plays' do
    it "should increase play_count by 1" do
      expect { project.play! }.to change(project, :play_count).by(1)
    end
  end

  context "with repo url" do
    let(:repository_url) { 'git://github.com/anonymous/endless_loops'} 
    let(:project) { create(:project, repository: repository_url) }

    it_should_behave_like 'project counting plays'
  end

  context "with uploaded log" do
    let(:project) { create(:project, log: File.open('spec/fixtures/history.log') ) }
    it_should_behave_like 'project counting plays'
  end
end
