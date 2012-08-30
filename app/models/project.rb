class Project < ActiveRecord::Base
  attr_accessible :name, :repository, :log

  mount_uploader :log, LogUploader
end
