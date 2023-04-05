require "rails_helper"

describe FormPolicy do
  subject(:policy) { described_class.new(user, form) }

  let(:form) { build :form, org: "gds" }
  let(:user) { build :user, organisation_slug: "gds" }

  context "with a form editor" do
    it { is_expected.to permit_actions(%i[can_view_form]) }

    context "but from another organisation" do
      let(:user) { build :user, organisation_slug: "non-gds" }

      it { is_expected.to forbid_actions(%i[can_view_form]) }
    end
  end

  describe FormPolicy::Scope do
    subject(:policy_scope) { described_class.new(user, Form) }

    let(:headers) do
      {
        "X-API-Token" => Settings.forms_api.auth_key,
        "Accept" => "application/json",
      }
    end

    let(:gds_forms) { build_list :form, 2, org: "gds" }

    context "with a form editor" do
      before do
        ActiveResource::HttpMock.respond_to do |mock|
          mock.get "/api/v1/forms?org=gds", headers, gds_forms.to_json, 200
        end
        policy_scope.resolve
      end

      it "Reads the forms from the API" do
        forms_request = ActiveResource::Request.new(:get, "/api/v1/forms?org=gds", {}, headers)
        expect(ActiveResource::HttpMock.requests).to include forms_request
      end
    end
  end
end