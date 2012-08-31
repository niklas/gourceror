class Project < ActiveRecord::Base
  attr_accessible :name, :repository, :log

  validates_presence_of :name

  mount_uploader :log, LogUploader

  class_attribute :resolution

  self.resolution = '800x600'

  def self.next_in_queue
    order('play_count ASC, created_at ASC').all.find(&:visualizable?)
  end

  def play_count
    super || 0
  end

  def play!
    return unless visualizable?
    pull if log.blank?
    run_gource
    increment(:play_count)
  end

  def visualizable?
    repository.present? or log.present?
  end

  def gource_arguments
    [].tap do |args|
      args << "-#{self.class.resolution}"
      args << '--file-idle-time 0'
      args << '-f'
      args << "--title '#{name_without_single_quotes}'"
      args << "--stop-at-end"

      if repository.blank? and log.present?
        args << log.file.path
      end
    end
  end

  def pull
    goto = %Q~mkdir -p #{repository_dir} && cd #{repository_dir}~
    if File.exist?( "#{repository_dir}/.git" )
      system %Q~#{goto} && git pull~
    else
      system %Q~#{goto} && git clone #{repository}~
    end
  end

  def repository_dir
    Rails.root.join("tmp/projects/#{id}")
  end

  def name_without_single_quotes
    name.gsub(/'/,'')
  end

  def run_gource
    system %Q~gource #{gource_arguments.join(' ')}~
  end
end
