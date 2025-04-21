require 'mini_magick'

module FileHelper
  def create_test_image(format: 'jpg')
    image = MiniMagick::Image.create("spec/fixtures/files/test_image.#{format}") do |f|
      f.combine_options do |c|
        c.size "300x300"
        c.background "white"
        c.gravity "center"
        c.extent "300x300"
      end
    end
  end
end
