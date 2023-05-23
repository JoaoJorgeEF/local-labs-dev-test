class StoriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @organization = Organization.where(slug: current_user.organization_slug).first
    @stories = Story.where(organization_id: @organization.id)
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)

    if @story.save
      redirect_to @story
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def story_params
    params.require(:article).permit(:headline, :body)
  end
end
