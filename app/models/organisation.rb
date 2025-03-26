class Organisation < ApplicationRecord
  include HasContentId

  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true, inclusion: { in: %w[live closed] }
  validates :organisation_type_key, inclusion: { in: OrganisationType.valid_keys }

  scope :filter_by_name, ->(name) { where("lower(organisations.name) like ?", "%#{name.strip.downcase}%") }

  extend FriendlyId
  friendly_id

  def organisation_type_key
    self[:organisation_type_key].nil? ? nil : self[:organisation_type_key].to_sym
  end

  def base_path
    "/organisations/#{slug}"
  end
end
