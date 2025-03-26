require "rails_helper"

RSpec.describe "/organisations", type: :request do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe "GET /index" do
    it "returns successfully" do
      get organisations_path
      expect(response).to have_http_status(:ok)
    end

    it "renders list of organisations" do
      create(:organisation, name: "test org")
      get organisations_path

      assert_select "table tr td:nth-child(1)", /test org/
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

      it "filters by status" do
        create(:organisation, name: "does-match1", status: "live")
        create(:organisation, name: "does-not-match", status: "closed")
        create(:organisation, name: "does-not-match2", status: "closed")

        get organisations_path, params: { status: "live" }

        assert_select "table tr td:nth-child(1)", text: /does-match/, count: 1
        assert_select "table tr td:nth-child(1)", text: /does-not-match/, count: 0
      end

      it "displays link to clear all filters" do
        get organisations_path
        assert_select "a", text: "Clear all filters", href: organisations_path
      end
    end
  end

  describe "GET /new" do
    it "returns successfully" do
      get new_organisation_path
      expect(response).to have_http_status(:ok)
    end

    it "renders a form for creating a new organisation" do
      get new_organisation_path

      expect(response.body).to include("New organisation")
      assert_select "form[action='#{organisations_path}']" do
        assert_select "input[name='organisation[name]']"
        assert_select "select[name='organisation[organisation_type_key]'][id='organisation_organisation_type_key']"
      end
    end
  end

  describe "POST /create" do
    let(:content_id) { "fde62e52-dfb6-42ae-b336-2c4faf068101" }
    let(:success_params) do
      {
        organisation: {
          name: "New org",
          organisation_type_key: "department",
          status: "live",
        },
      }
    end

    let!(:put_request) { stub_request(:put, %r{.*publishing-api.*/content/#{content_id}}) }
    let!(:publish_request) { stub_request(:post, %r{.*publishing-api.*/content/#{content_id}/publish}) }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(content_id)
    end

    it "redirects to organisations path on success" do
      post organisations_path, params: success_params
      expect(response).to redirect_to(organisations_path)
      follow_redirect!
      expect(response.body).to include("Created organisation New org successfully")
    end

    it "creates a new organisation" do
      expect {
        post organisations_path, params: success_params
      }.to change(Organisation, :count).by(1)
    end

    it "sends new organisation and index page downstream" do
      post organisations_path, params: success_params
      expect(put_request).to have_been_requested.times(2)
      expect(publish_request).to have_been_requested.times(2)
    end

    it "displays error and does not create organisation if name is not provided" do
      post organisations_path, params: {
        organisation: {
          organisation_type_key: "department",
          status: "live",
        },
      }

      expect(response.body).to include("Name can't be blank")
      expect(Organisation.count).to be(0)
    end

    it "displays error and does not create organisation if organisation_type_key is not provided" do
      post organisations_path, params: {
        organisation: {
          name: "New org",
          status: "live",
        },
      }

      expect(response.body).to include("Organisation type key is not included in the list")
      expect(Organisation.count).to be(0)
    end

    it "displays error and does not create organisation if status is not provided" do
      post organisations_path, params: {
        organisation: {
          name: "New org",
          organisation_type_key: "department",
        },
      }

      expect(response.body).to include("Status can't be blank")
      expect(Organisation.count).to be(0)
    end
  end
end
