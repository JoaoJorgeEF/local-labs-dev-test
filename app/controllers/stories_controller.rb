class StoriesController < ApplicationController
  
  skip_before_action :verify_authenticity_token
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

    if @story.writer_id
      @story.set_writer
    end

    if @story.save
      redirect_to stories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @story = Story.find(params[:id])

    if current_user.chief_editor?
      @users = User.where(organization_slug: current_user.organization_slug).where.not(id: current_user.id)
    elsif current_user.id == @story.reviewer_id

      if @story.for_review?
        @story.start_review
        @story.save
      end

    end
    
  end

  def update
    @story = Story.find(params[:id])

    if @story.pending?
      @story.back_to_draft
    end

    if @story.update(story_params)
      redirect_to edit_story_path(@story.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def change_status
    @story = Story.find(params[:id])

    if !current_user.chief_editor? && current_user.id != @story.reviewer_id && current_user.id != @story.writer_id
      render :edit, status: :unprocessable_entity
    else
      case params[:status]
      when "request_review"
        @story.request_review
      when "request_changes"
        @story.request_changes
      when "approve"
        @story.approve
      when "publish"
        @story.publish
      when "archive"
        @story.archive
      end
  
      if @story.save
        redirect_to edit_story_path(@story.id)
      else
        render :edit, status: :unprocessable_entity
      end
    end

  end

  private
  def story_params
    params.require(:story).permit(:writer_id, :reviewer_id, :headline, :body)
  end

  def set_organization
    @organization = Organization.find_by(slug: current_user.organization_slug)
  end
end
