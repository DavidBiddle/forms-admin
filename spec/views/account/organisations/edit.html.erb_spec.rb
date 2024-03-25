require "rails_helper"

describe "account/organisations/edit.html.erb" do
  let(:organisation_form) { Account::OrganisationForm.new }
  let!(:organisations) { create_list(:organisation, 3) }
  let(:contact_href) { "https://example.com/contact" }

  before do
    assign(:organisation_form, organisation_form)
    allow(view).to receive(:contact_link).and_return(contact_href)
  end

  context "when there are no errors" do
    before do
      render
    end

    it "displays the form" do
      expect(rendered).to have_selector('form[action="/account/organisation"][method="post"]')
      expect(rendered).to have_field("_method", with: "patch", type: :hidden)
      expect(rendered).to have_button(I18n.t("save_and_continue"))
    end

    it "renders the organisation select field for autocomplete" do
      expect(rendered).to have_selector('select[name="account_organisation_form[organisation_id]"]', visible: :all)
      organisations.each do |organisation|
        expect(rendered).to have_selector("option[value='#{organisation.id}']", text: organisation.name)
      end
    end

    it "sets the page title" do
      expect(view.content_for(:title)).to eq(t("page_titles.account_organisation"))
    end
  end

  context "when there are errors" do
    before do
      organisation_form.errors.add(:base, "Some error")
      render
    end

    it "displays the error summary" do
      expect(rendered).to have_selector(".govuk-error-summary")
    end

    it "sets the page title with error prefix" do
      expect(view.content_for(:title)).to eq(title_with_error_prefix(t("page_titles.account_organisation"), true))
    end
  end
end
