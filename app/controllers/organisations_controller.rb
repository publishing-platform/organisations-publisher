class OrganisationsController < ApplicationController
  before_action :build_organisation, only: %i[new create]
  before_action :load_organisation, except: %i[index new create]

  def index
    @organisations = Organisation.all
    @filter_params = filter_params

    filter_organisations
    order_organisations
  end

  def new; end

  def create
    @organisation.assign_attributes(organisation_params)

    if @organisation.save
      publish_organisation
      redirect_to organisations_path, notice: "Created organisation #{@organisation.name} successfully"
    else
      Rails.logger.debug @organisation.errors.full_messages
      render :new
    end
  end

  def show; end

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

  def load_organisation
    @organisation = Organisation.friendly.find(params[:id])
  end

  def filter_organisations
    @organisations = @organisations.filter_by_name(@filter_params[:name]) if @filter_params[:name].present?
    @organisations = @organisations.where(organisation_type_key: @filter_params[:organisation_type_key]) if @filter_params[:organisation_type_key].present?
    @organisations = @organisations.where(status: @filter_params[:status]) if @filter_params[:status].present?
  end

  def order_organisations
    @organisations = @organisations.order(:name)
  end

  def filter_params
    params.permit(:name, :organisation_type_key, :status)
  end

  def publish_organisation
    presenter = PublishingApi::OrganisationPresenter.new(@organisation)

    PublishingPlatformApi.publishing_api.put_content(@organisation.content_id, presenter.content)
    PublishingPlatformApi.publishing_api.publish(@organisation.content_id)
  end
end
