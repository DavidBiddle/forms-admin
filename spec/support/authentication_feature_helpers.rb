module AuthenticationFeatureHelpers
  def login_as(user)
    GDS::SSO.test_user = user
  end

  def logout
    GDS::SSO.test_user = nil
  end

  def editor_user
    @editor_user ||= FactoryBot.build(:user)
  end

  def super_admin_user
    @super_admin_user ||= FactoryBot.build(:user, :super_admin)
  end

  def login_as_editor_user
    login_as editor_user
  end

  def login_as_super_admin_user
    login_as super_admin_user
  end
end

RSpec.configure do |config|
  config.include AuthenticationFeatureHelpers, type: :feature
  config.include AuthenticationFeatureHelpers, type: :request
  config.before(:example, type: :feature) do
    login_as_editor_user
  end
  config.before(:example, type: :request) do
    login_as_editor_user
  end
end