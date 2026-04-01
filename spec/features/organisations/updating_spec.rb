require "rails_helper"

RSpec.feature "Updating an organisation", type: :feature do
  before do
    create(:user)
  end

  scenario do
    given_there_is_an_organisation
    when_i_visit_the_edit_organisation_page
    and_i_fill_in_the_fields
    then_i_see_the_updated_organisation
  end

  def given_there_is_an_organisation
    @organisation = create(:organisation)
  end

  def when_i_visit_the_edit_organisation_page
    visit edit_organisation_path(@organisation)
    expect(page).to have_content("Organisations")
  end

  def and_i_fill_in_the_fields
    stub_request(:put, %r{.*publishing-api.*/content/.*})
    stub_request(:post, %r{.*publishing-api.*/content/.*})

    fill_in "Name", with: "Updated organisation"
    select "Other"
    choose "Closed"

    click_on "Save organisation"
  end

  def then_i_see_the_updated_organisation
    expect(page).to have_content("1 organisation")
    expect(page).to have_content("Updated organisation")
    expect(page).to have_content("Other")
    expect(page).to have_content("Closed")
  end
end
