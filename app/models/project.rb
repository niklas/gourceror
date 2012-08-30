class Project < ActiveRecord::Base
  attr_accessible :name, :repository, :log

  mount_uploader :log, LogUploader

  def play_count
    super || 0
  end

  def play!
    increment(:play_count)
  end
end
