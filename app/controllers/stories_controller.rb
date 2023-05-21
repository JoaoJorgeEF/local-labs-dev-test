class StoriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @organization = Organization.where(slug: current_user.organization_slug).first
    @stories = Story.where(organization_id: @organization.id)
  end
end
