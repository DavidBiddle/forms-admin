require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  context "when a user is logged in who does not have access" do
    let(:headers) do
      {
        "X-API-Token" => Settings.forms_api.auth_key,
        "Accept" => "application/json",
      }
    end

    let(:user) { build :user, :super_admin, has_access: false }
    let(:form) { build :form, id: 1 }

    before do
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get "/api/v1/forms?org=test-org", headers, [form].to_json, 200
        mock.get "/api/v1/forms/1", headers, form.to_json, 200
        mock.get "/api/v1/forms/1/pages", headers, form.pages.to_json, 200
      end

      login_as user
    end

    [
      "/",
      "/users",
      "/forms/1",
    ].each do |path|
      context "when accessing #{path}" do
        before do
          get path
        end

        it "returns http code 403 for #{path}" do
          expect(response).to have_http_status(:forbidden)
        end

        it "renders the access denied page" do
          expect(response).to render_template("errors/access_denied")
        end
      end
    end
  end
end