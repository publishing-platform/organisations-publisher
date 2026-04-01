require "rails_helper"

RSpec.feature "Creating an organisation", type: :feature do
  before do
    create(:user)
  end

  scenario do
    given_i_am_on_the_index_page
    when_i_click_to_create_an_organisation
    and_i_fill_in_the_fields
    then_i_see_the_new_organisation
  end

  def given_i_am_on_the_index_page
    visit organisations_path
    expect(page).to have_content("Organisations")
  end

  def when_i_click_to_create_an_organisation
    click_on "Create new organisation"
    expect(page).to have_content("New organisation")
  end

  def and_i_fill_in_the_fields
    stub_request(:put, %r{.*publishing-api.*/content/.*})
    stub_request(:post, %r{.*publishing-api.*/content/.*})

    fill_in "Name", with: "A new organisation"
    select "Department"
    choose "Live"

    click_on "Save organisation"
  end

  def then_i_see_the_new_organisation
    expect(page).to have_content("1 organisation")
    expect(page).to have_content("A new organisation")
  end
end
