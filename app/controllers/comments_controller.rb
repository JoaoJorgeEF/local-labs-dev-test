class CommentsController < ApplicationController
    def create
        @story = Story.find(params[:story_id])
        @comment = @story.comments.create(user_id: current_user.id, body: comment_params[:body])
        redirect_to edit_story_path(@story.id)
    end

    private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
