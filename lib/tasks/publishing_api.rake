require_relative "../publish_organisations_api_route"

namespace :publishing_api do
  desc "Publish organisations"
  task publish_organisations: :environment do
    PublishOrganisations.new.publish
  end

  desc "Publish the /api/organisations prefix route"
  task publish_organisations_api_route: :environment do
    PublishOrganisationsApiRoute.new.publish
  end
end
