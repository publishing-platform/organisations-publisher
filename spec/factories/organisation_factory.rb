FactoryBot.define do
  factory :organisation do
    sequence(:name) { |index| "organisation-#{index}" }
    organisation_type_key { :department }
    status { "live" }
  end
end
