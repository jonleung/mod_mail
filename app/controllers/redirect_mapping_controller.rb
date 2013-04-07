class RedirectMappingController < ApplicationController

  def get
    redirect_mapping = RedirectMapping.find_by_image_tag_uri()
    redirect_to redirect_mapping.url
  end

end