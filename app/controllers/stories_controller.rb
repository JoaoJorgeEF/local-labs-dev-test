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

    if @story.writer_id
      @story.set_writer
    end

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
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
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def request_review
    @story = Story.find(params[:id])

    if current_user.id != @story.writer_id
      render :edit, status: :unprocessable_entity
    end

    @story.request_review

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def request_changes
    @story = Story.find(params[:id])

    if current_user.id != @story.reviewer_id
      render :edit, status: :unprocessable_entity
    end

    @story.request_changes

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def approve
    @story = Story.find(params[:id])

    if current_user.id != @story.reviewer_id
      render :edit, status: :unprocessable_entity
    end

    @story.approve

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    @story = Story.find(params[:id])

    if !current_user.chief_editor?
      render :edit, status: :unprocessable_entity
    end

    @story.publish

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @story = Story.find(params[:id])

    if !current_user.chief_editor?
      render :edit, status: :unprocessable_entity
    end

    @story.archive

    if @story.save
      redirect_to organization_stories_path(organization_id: @organization.id)
    else
      render :edit, status: :unprocessable_entity
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
