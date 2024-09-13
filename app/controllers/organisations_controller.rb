class OrganisationsController < ApplicationController
  before_action :build_organisation, only: %i[new create]

  def index
    a = OrganisationType.valid_keys
    Rails.logger.debug a
  end

  def new; end

  def create
    @organisation.assign_attributes(organisation_params)

    if @organisation.save
      redirect_to organisations_path, notice: "Created organisation #{@organisation.name} successfully"
    else
      Rails.logger.debug @organisation.errors.full_messages
      render :new
    end
  end

private

  def organisation_params
    params.require(:organisation).permit(
      :name,
      :abbreviation,
      :organisation_type_key,
      :status,
    ).to_h
  end

  def build_organisation
    @organisation = Organisation.new
  end
end
