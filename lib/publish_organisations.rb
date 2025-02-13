class PublishOrganisations
  def publish
    organisations = load_organisations

    organisations.each do |org|
      organisation = Organisation.find_by(content_id: org[:content_id])
      if !organisation
        puts "creating organisation #{org[:name]}"
        organisation = Organisation.new(org)

        if organisation.save
          publish_organisation(organisation)
        else
          puts "error creating organisation #{org[:name]}"
        end
      else
        puts "skipping existing organisation with content_id #{org[:content_id]}"
      end
    end

    puts "publishing organisations index page"
    publish_organisations_index_page
  end

private

  def load_organisations
    YAML.load_file(Rails.root.join("lib/data/organisations.yaml"))
  end

  def publish_organisation(organisation)
    presenter = PublishingApi::OrganisationPresenter.new(organisation)

    PublishingPlatformApi.publishing_api.put_content(organisation.content_id, presenter.content)
    PublishingPlatformApi.publishing_api.publish(organisation.content_id)
  end

  def publish_organisations_index_page
    presenter = PublishingApi::OrganisationsIndexPresenter.new

    PublishingPlatformApi.publishing_api.put_content(presenter.content_id, presenter.content)
    PublishingPlatformApi.publishing_api.publish(presenter.content_id)
  end
end
