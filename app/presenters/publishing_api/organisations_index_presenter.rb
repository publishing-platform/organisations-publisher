module PublishingApi
  class OrganisationsIndexPresenter
    def content_id
      "fde62e52-dfb6-42ae-b336-2c4faf068101"
    end

    def content
      {
        title:,
        description: "Information from departments and other organisations, including news, campaigns, policies and contact details.",
        schema_name:,
        document_type: "finder",
        publishing_app: OrganisationsPublisher::PublishingApp::ORGANISATIONS_PUBLISHER,
        rendering_app: OrganisationsPublisher::RenderingApp::COLLECTIONS_FRONTEND,
        update_type: "major",
        base_path:,
        routes: [
          { path: base_path, type: "exact" },
        ],
        details: organisations_list,
      }
    end

  private

    def title
      "Departments and other organisations"
    end

    def base_path
      "/organisations"
    end

    def schema_name
      "organisations_homepage"
    end

    def organisations_list
      {
        ordered_departments: organisation_details_by_type(:department),
      }
    end

    def organisation_details(organisation)
      {
        title: organisation.name,
        href: organisation.base_path,
        organisation_type: organisation.organisation_type_key.to_s,
        slug: organisation.slug,
        abbreviation: organisation.abbreviation,
        status: organisation.status,
        content_id: organisation.content_id,
      }
    end

    def organisation_details_by_type(type)
      grouped_organisations.fetch(type, []).map { |org| organisation_details(org) }
    end

    def grouped_organisations
      @grouped_organisations ||= sorted_organisations.group_by(&:organisation_type_key)
    end

    def sorted_organisations
      @sorted_organisations ||= Organisation.all.sort_by(&:name)
    end
  end
end
