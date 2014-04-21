class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  mount_uploader :source, ImageUploader

  def thumb_url
    source.thumb.url
  end
end
