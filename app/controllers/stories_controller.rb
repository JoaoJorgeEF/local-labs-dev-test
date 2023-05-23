class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization


  def index
    # @organization = Organization.where(slug: current_user.organization_slug).first
    @stories = Story.where(organization_id: @organization.id)
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    authorize Story, :chief_editor?

    @story = Story.new
    @users = User.where(organization_slug: current_user.organization_slug).where.not(id: current_user.id)
  end

  def create
    authorize Story, :chief_editor?

    @story = Story.new(headline: story_params[:headline], body: story_params[:body], writer_id: story_params[:writer_id], reviewer_id: story_params[:reviewer_id], organization: @organization)

    puts @story.story_status
    if @story.writer_id
      @story.set_writer_event!
      puts @story.story_status
      puts @story.story_status.class
    end

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def story_params
    params.require(:story).permit(:writer_id, :reviewer_id, :headline, :body)
  end

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
end
