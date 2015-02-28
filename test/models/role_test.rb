require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "role must be valid" do
    role = Role.new(name: "Admin")
    
    role.permissions << permissions(:user_manage)
    
    assert role.save
  end
  
  test "role attributes must not be empty" do
    blank_message = I18n.translate('errors.messages.blank')
    role = Role.new
    
    assert role.invalid?
    assert_equal blank_message,
                 role.errors[:name].join('; ')
  end
  
  test "role is not valid without a unique name" do
    role = Role.new(name: roles(:super_admin).name)

    assert role.invalid?
    assert_equal I18n.translate('errors.messages.taken'),
                 role.errors[:name].join('; ')
  end
end
