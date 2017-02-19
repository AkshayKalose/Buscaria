class PagesController < ApplicationController
  def show
    render template: "pages/index" #"pages/#{params[:page]}"
  end
end
