require "rails_helper"

RSpec.describe OrganisationType, type: :model do
  it "takes a key and name as initialize arguments and exposes them as properties" do
    instance = described_class.new(
      :some_type_key,
      name: "A Name",
    )

    expect(instance.key).to eq :some_type_key
    expect(instance.name).to eq "A Name"
  end

  describe ".get" do
    it "returns an instance populated with the correct attributes" do
      expect(described_class.get(:department).name).to eq "Department"
      expect(described_class.get(:department).key).to eq :department
    end

    it "accepts keys as strings" do
      expect(described_class.get("department").name).to eq "Department"
    end

    it "throws a KeyError if bad key is given" do
      expect {
        described_class.get(:non_existant_org_type)
      }.to raise_error(KeyError)
    end

    it "returns the same instance when called a second time with the same key" do
      instance1 = described_class.get(:department)
      instance2 = described_class.get(:department)

      expect(instance1).to equal(instance2)
    end
  end

  describe ".valid_keys" do
    it "returns all keys on DATA" do
      expect(OrganisationType::DATA.keys).to eq(described_class.valid_keys)
    end
  end
end
