 # MagickTitle.options = { :root => "./", :font => "HelveticaNeueLTPro-Lt.otf", :font_path => Proc.new{ File.join MagickTitle.root, "fonts" }, :font_size => 12, :destination => Proc.new{ File.join MagickTitle.root, "public/system/titles" }, :extension => "png", :text_transform => nil, :width => 12, :height => nil, :background_color => '#ffffff', :background_alpha => '00', :color => '#000000', :weight => 300, :kerning => 0, :line_height => 0, :command_path => nil, :log_command => false, :cache => true }

MagickTitle.options = {
  :root => "./",
  :font => "arial.ttf",
  :font_path => Proc.new{ File.join MagickTitle.root, "fonts" },
  :font_size => 15,
  :destination => Proc.new{ File.join MagickTitle.root, "public/system/titles" },
  :extension => "png",
  :text_transform => nil,
  :width => 100,
  :height => nil,
  :background_color => '#ffffff',
  :background_alpha => '00',
  :color => '#000000',
  :weight => 300,
  :kerning => 0,
  :line_height => 0,
  :command_path => nil,
  :log_command => true,
  :cache => true,
    :to_html => {
    :parent => {
      :tag   => "span",
      :class => "character-parent"
    },
    :class => "character"
  }

}

=begin
=end