class Ability
  include CanCan::Ability

  def initialize(user)
    user.roles.each do |role|
      can :manage, :all if role.name == 'SuperAdmin'
      role.permissions.each do |permission|
        can permission.action_name.to_sym, permission.object_type.constantize
      end
    end
  end
end
