class CommentsController < ApplicationController


  def create
    comment = Comment.new

    comment.author_id = nil
    if (session[:current_user_id] != nil)
      comment.author_id = session[:current_user_id]
    else
      comment.author_id = params.fetch("input_author_id")
    end
    comment.photo_id = params.fetch("input_photo_id")
    comment.body = params.fetch("input_body")

    comment.save

    redirect_to("/photos/#{comment.photo_id}")
  end


end
