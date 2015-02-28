require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :app_db do
  desc "teste"
  task setup: :environment do
    setup_actions_models
    setup_admin_user
  end
  
  desc "teste"
  task setup_actions_models: :environment do
    setup_actions_models
  end
  
  desc "teste"
  task setup_admin_user: :environment do
    setup_admin_user
  end
  
  private
    def setup_actions_models
      # List models
      models = Dir['app/models/*.rb'].map {|f| File.basename(f, '.*').camelize.constantize.name }.reject!{|m| m.constantize.superclass != ActiveRecord::Base }

      # For each model and action_methods write an action to permission
      models.each do |model|
        clazz = model.to_s
        setup_permission(clazz, "manage")
        setup_permission(clazz, "read")
        setup_permission(clazz, "create")
        setup_permission(clazz, "update")
        setup_permission(clazz, "destroy")
      end
    end
    
    def setup_permission(class_name, cancan_action)
      permission  = Permission.where(object_type: class_name, action_name: cancan_action).first
      if not permission
        permission = Permission.new
        permission.object_type = class_name
        permission.action_name = cancan_action
        permission.save!
      end
      permission
    end
    
    def setup_admin_user(email = "admin@admin.com.br", password = "123456789")
      user = User.where(email: email).first
      
      if not user
        user = User.new(full_name: "Administrator",
                        email: email,
                        password: password)
        user.roles << setup_super_admin_role
        user.save!
      end
      
      user
    end
    
    def setup_super_admin_role
      role = Role.where(name: "SuperAdmin").first
      
      if not role
        role = Role.new(name: "SuperAdmin")
        role.save!
      end
      
      role
    end
end
