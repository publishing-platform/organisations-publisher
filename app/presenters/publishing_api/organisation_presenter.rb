module PublishingApi
  class OrganisationPresenter
    attr_accessor :organisation

    def initialize(organisation)
      self.organisation = organisation
    end

    def content
      {
        title: organisation.name,
        schema_name:,
        document_type: schema_name,
        publishing_app: OrganisationsPublisher::PublishingApp::ORGANISATIONS_PUBLISHER,
        rendering_app: OrganisationsPublisher::RenderingApp::COLLECTIONS_FRONTEND,
        update_type: "major",
        base_path: organisation.base_path,
        routes: [
          { path: organisation.base_path, type: "prefix" },
        ],
        details:,
      }
    end

  private

    def schema_name
      "organisation"
    end

    def details
      {
        abbreviation: organisation.abbreviation,
        organisation_type: organisation.organisation_type_key.to_s,
        status: organisation.status,
      }
    end
  end
end
