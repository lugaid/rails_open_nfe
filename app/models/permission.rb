class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  validates_presence_of :object_type, :action_name
  
  validates_uniqueness_of :object_type, scope: [:action_name]
  
  def permission_description
    "#{self.action_name.titleize} - #{self.object_type.titleize}"
  end
end
