require "rails_helper"

RSpec.describe Organisation, type: :model do
  it "is invalid without a name" do
    organisation = build(:organisation, name: nil)

    expect(organisation.valid?).to be false
  end

  it "is invalid with a duplicate name" do
    existing_organisation = create(:organisation)
    new_organisation = build(:organisation, name: existing_organisation.name)

    expect(new_organisation.valid?).to be false
  end

  it "is invalid if status is not live or closed" do
    organisation = build(:organisation, status: "something-else")
    expect(organisation.valid?).to be false
  end

  it "is invalid if organisation_type_key is not a permitted value" do
    organisation = build(:organisation, organisation_type_key: "something-else")
    expect(organisation.valid?).to be false
  end

  it "sets a slug from the organisation name" do
    organisation = create(:organisation, name: "Love all the people")
    expect(organisation.slug).to eq("love-all-the-people")
  end

  it "does not change the slug when the name is changed" do
    organisation = create(:organisation, name: "Love all the people")
    organisation.update!(name: "Hold hands")
    expect(organisation.slug).to eq("love-all-the-people")
  end

  it "does not include apostrophes in slug" do
    organisation = create(:organisation, name: "Bob's bike")
    expect(organisation.slug).to eq("bobs-bike")
  end

  it "adds prefix to base_path" do
    organisation = create(:organisation)
    expect(organisation.base_path).to eq("/organisations/#{organisation.slug}")
  end
end
