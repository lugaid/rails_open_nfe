require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  test "permission must be valid" do
    permission = Permission.new(object_type: "User",
                                action_name: "read")
    
    assert permission.save
  end
  
  test "permission attributes must not be empty" do
    blank_message = I18n.translate('errors.messages.blank')
    permission = Permission.new
    
    assert permission.invalid?
    assert_equal blank_message,
                 permission.errors[:object_type].join('; ')
    assert_equal blank_message,
                 permission.errors[:action_name].join('; ')
  end
  
  test "permission is not valid without a unique object_type and action_name" do
    permission = Permission.new(object_type: permissions(:user_manage).object_type,
                                action_name: permissions(:user_manage).action_name)

    assert permission.invalid?
    assert_equal I18n.translate('errors.messages.taken'),
                 permission.errors[:object_type].join('; ')
  end
  
  test "permission description format" do
    user_manage = permissions(:user_manage)
    
    assert_equal user_manage.permission_description,
                 "#{user_manage.action_name.titleize} - #{user_manage.object_type.titleize}"
  end
end
