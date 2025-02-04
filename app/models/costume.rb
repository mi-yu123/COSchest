class Costume < ApplicationRecord
  has_one_attached :image

  enum status: { completed: 0, incomplete: 1 }

  after_commit :resize_image, on: %i[create update]

  private

  def resize_image
    return unless image.attached?

    image = MiniMagick::Image.read(self.image.download)
    image.resize '300x300'
    image = image.crop '300x300+0+0'

    io = StringIO.new(image.to_blob)
    io.class.class_eval { include ActiveStorage::Blob::Analyzable }
    self.image.attach(io: io, filename: image.filename)
  end
end
