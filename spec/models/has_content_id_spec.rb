require "rails_helper"

RSpec.describe HasContentId do
  # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
  class TestObject
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    include HasContentId

    attr_accessor :content_id
  end
  # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

  it "generates a uuid content id" do
    expected_content_id = SecureRandom.uuid
    allow(SecureRandom).to receive(:uuid).and_return(expected_content_id)
    object = TestObject.new

    object.validate

    expect(object.content_id).to eq expected_content_id
  end

  it "rejects invalid uuids" do
    object = TestObject.new(content_id: "abcde")

    object.validate

    expect(object.errors[:content_id]).to eq ["is invalid"]
  end
end
