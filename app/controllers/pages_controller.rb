class PagesController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated

    def media
      # Fetch only the current user's posts
      @posts = current_user.posts
    end
end
