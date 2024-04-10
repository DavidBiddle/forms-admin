require "rails_helper"

feature "Add account organisation to user without organisation", type: :feature do
  let(:user) { create :user, :with_no_org, name: nil }
  let!(:organisation) { create :organisation }

  before do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/api/v1/forms?creator_id=#{user.id}", headers, [].to_json, 200
    end

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:auth0] = Faker::Omniauth.auth0(
      uid: user.uid,
      email: user.email,
    )

    allow(Settings).to receive(:auth_provider).and_return("auth0")
  end

  after do
    OmniAuth.config.mock_auth[:auth0] = nil
    OmniAuth.config.test_mode = false
  end

  scenario "when the user does not have an organisation or name" do
    when_i_visit_a_page_which_requires_sign_in
    then_i_should_be_redirected_to_the_account_organisation_page
    and_i_select_an_organisation
    then_i_should_be_redirected_to_the_account_name_page
    and_i_fill_in_my_name
    then_i_should_be_redirected_to_my_original_destination
  end

private

  def when_i_visit_a_page_which_requires_sign_in
    visit new_user_upgrade_request_path
  end

  def then_i_should_be_redirected_to_the_account_organisation_page
    expect(page).to have_content("Select your organisation")
  end

  def and_i_select_an_organisation
    fill_in "Select your organisation", with: "#{organisation.name}\n"
    click_button "Save and continue"
  end

  def then_i_should_be_redirected_to_the_account_name_page
    expect(page).to have_content("Enter your full name")
  end

  def and_i_fill_in_my_name
    fill_in "Enter your full name", with: "John Doe"
    click_button "Save and continue"
  end

  def then_i_should_be_redirected_to_my_original_destination
    expect(page).to have_current_path(new_user_upgrade_request_path)
  end
end
