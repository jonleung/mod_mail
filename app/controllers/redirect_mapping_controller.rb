class RedirectMappingController < ApplicationController

  def get
    redirect_to RedirectMapping.find_image_url_by_image_tag_uri(params[:image_tag_uri])
  end

end