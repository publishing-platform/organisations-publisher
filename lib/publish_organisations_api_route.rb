class PublishOrganisationsApiRoute
  def publish
    publishing_api = PublishingPlatformApi.publishing_api
    payload = present_for_publishing_api

    publishing_api.put_content(payload[:content_id], payload[:content])
    publishing_api.publish(payload[:content_id])
  end

private

  BASE_PATH = "/api/organisations".freeze
  CONTENT_ID = "6848a0b0-8cd0-4641-ac3f-5e70379be309".freeze

  def present_for_publishing_api
    {
      content_id: CONTENT_ID,
      content: {
        title: "Organisations API",
        description: "API exposing all organisations on Publishing Platform.",
        document_type: "special_route",
        schema_name: "special_route",
        base_path: BASE_PATH,
        publishing_app: OrganisationsPublisher::PublishingApp::ORGANISATIONS_PUBLISHER,
        rendering_app: OrganisationsPublisher::RenderingApp::COLLECTIONS_FRONTEND,
        routes: [
          {
            path: BASE_PATH,
            type: "prefix",
          },
        ],
        public_updated_at: Time.zone.now.iso8601,
        update_type: "minor",
      },
    }
  end
end
