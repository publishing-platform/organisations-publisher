require "rails_helper"

RSpec.describe "Organisation filtering", type: :system do
  scenario do
    create(:user)

    given_there_are_some_organisations
    when_i_visit_the_index_page
    then_i_see_all_organisations

    when_i_clear_the_filters
    and_i_filter_by_name
    then_i_see_just_the_ones_that_match

    when_i_clear_the_filters
    then_i_see_all_organisations

    when_i_filter_by_organisation_type
    then_i_see_just_the_ones_that_match

    when_i_clear_the_filters
    and_i_filter_by_status
    then_i_see_just_the_ones_that_match

    when_i_clear_the_filters
    and_i_filter_too_much
    then_i_see_there_are_no_results
  end

  def given_there_are_some_organisations
    @relevant_organisation = create(:organisation, name: "Super relevant")
    @irrelevant_organisation = create(:organisation, organisation_type_key: :other, status: "closed", name: "Irrelevant")
  end

  def when_i_visit_the_index_page
    visit organisations_path
  end

  def then_i_see_all_organisations
    expect(page).to have_content("2 organisations")
  end

  def and_i_filter_by_name
    fill_in "name", with: "super"
    click_on "Filter"
  end

  def when_i_clear_the_filters
    click_on "Clear all filters"
  end

  def then_i_see_just_the_ones_that_match
    expect(page).to have_content("1 organisation")
    expect(page).to have_content(@relevant_organisation.name)
  end

  def when_i_filter_by_organisation_type
    select OrganisationType.get(@relevant_organisation.organisation_type_key).name, from: "organisation_type_key"
    click_on "Filter"
  end

  def and_i_filter_by_status
    select @relevant_organisation.status.capitalize, from: "status"
    click_on "Filter"
  end

  def and_i_filter_too_much
    fill_in "name", with: SecureRandom.uuid
    click_on "Filter"
  end

  def then_i_see_there_are_no_results
    expect(page).to have_content("0 organisations")
  end
end
