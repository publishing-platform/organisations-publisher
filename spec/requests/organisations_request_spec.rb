require "rails_helper"

RSpec.describe "/organisations", type: :request do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe "GET /index" do
    it "renders list of organisations" do
      create(:organisation, name: "test org")
      get organisations_path

      expect(response).to have_http_status(:ok)
      assert_select "table tr td:nth-child(1)", /test org/
    end
  end

  it "renders link to create a new organisation" do
    get organisations_path

    assert_select "a[href='#{new_organisation_path}']", text: "Create new organisation"
  end

  context "when filtering" do
    it "filters by partially matching name" do
      create(:organisation, name: "does-match1")
      create(:organisation, name: "does-match2")
      create(:organisation, name: "does-not-match")

      get organisations_path, params: { name: "does-match" }

      assert_select "table tr td:nth-child(1)", text: /does-match/, count: 2
      assert_select "table tr td:nth-child(1)", text: /does-not-match/, count: 0
    end

    it "filters by organisation type" do
      create(:organisation, name: "does-match1", organisation_type_key: :department)
      create(:organisation, name: "does-match2", organisation_type_key: :department)
      create(:organisation, name: "does-not-match", organisation_type_key: :other)

      get organisations_path, params: { organisation_type_key: "department" }

      assert_select "table tr td:nth-child(1)", text: /does-match/, count: 2
      assert_select "table tr td:nth-child(1)", text: /does-not-match/, count: 0
    end
  end
end
