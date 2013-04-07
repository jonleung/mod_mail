module HtmlHelper

  def self.build_and_wrap_image(url)
    return %{<img src="#{url}">}
  end

  def self.wrap_all_image_tags(image_tags_html)
    return %{<html><body>#{image_tags_html}</body></html>}
  end

end