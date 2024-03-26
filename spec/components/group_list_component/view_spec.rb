require "rails_helper"

RSpec.describe GroupListComponent::View, type: :component do
  subject(:group_list) { described_class.new(groups:, title:, empty_message:) }

  let(:groups) { create_list(:group, 3) }
  let(:title) { "Your Groups" }
  let(:empty_message) { "There are no groups to display" }

  describe "rendering component" do
    before do
      render_inline(group_list)
    end

    it "renders the title as a table caption" do
      expect(page).to have_css("caption", text: title)
    end

    it "renders a table with the groups" do
      expect(page).to have_css("table")
      expect(page).to have_css("tr", count: 4)
    end

    context "when there are no groups" do
      let(:groups) { [] }

      it "renders a message" do
        expect(page).to have_css("p", text: empty_message)
      end

      it "shows the title as a heading" do
        expect(page).to have_css("h2", text: title)
      end
    end

    context "when the group creator is known" do
      let(:user) { create :user }
      let(:groups) { create_list(:group, 3, creator: user) }

      it "renders the creator's name" do
        expect(page).to have_css("tr", count: 3, text: user.name)
      end
    end

    context "when the group creator is unknown" do
      let(:groups) { create_list(:group, 3, creator: nil) }

      it "renders the creator as unknown" do
        expect(page).to have_css("tr", count: 3, text: "Unknown")
      end
    end
  end
end
