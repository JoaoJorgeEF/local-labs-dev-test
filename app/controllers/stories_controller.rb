class StoriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @stories = Story.where(organization_id: params[:organization_id])
  end
end
