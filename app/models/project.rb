class Project < ActiveRecord::Base
  attr_accessible :name, :repository, :log

  validates_presence_of :name

  mount_uploader :log, LogUploader

  class_attribute :resolution

  self.resolution = '1280x720'

  Advertisment = "register your app at http://halde.local:7777/"

  def self.next_in_queue
    order('play_count ASC, created_at ASC').all.find(&:visualizable?)
  end

  def play_count
    super || 0
  end

  def play!
    return unless visualizable?
    pull if log.blank?
    run_gource && increment(:play_count)
  end

  def visualizable?
    repository.present? or log.present?
  end

  def gource_arguments
    [].tap do |args|
      args << "-#{self.class.resolution}"
      args << '--file-idle-time 0'
      args << '-f'
      args << "--title '#{name_without_single_quotes}' [#{Advertisment}]"
      args << "--stop-at-end"

      if repository.blank? and log.present?
        args << log.file.path
      elsif repository.present?
        args << repository_dir
      end
    end
  end

  def pull
    if File.exist?( "#{repository_dir}" )
      system %Q~mkdir -p #{repository_dir} && cd #{repository_dir} && git pull~
    else
      system %Q~mkdir -p #{base_dir} && cd #{base_dir} && git clone #{repository} #{id}~
    end
  end

  def base_dir
    Rails.root.join("tmp/projects")
  end

  def repository_dir
    base_dir.join(id.to_s)
  end

  def name_without_single_quotes
    name.gsub(/'/,'')
  end

  def run_gource
    system %Q~gource #{gource_arguments.join(' ')}~
  end
end
