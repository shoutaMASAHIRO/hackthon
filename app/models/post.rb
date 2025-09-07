class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy

  has_one_attached :image

  # 任意: バリデーション（サイズ/拡張子）
  validate :acceptable_image

  private
  def acceptable_image
    return unless image.attached?
    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
    acceptable_types = ["image/jpeg", "image/png", "image/webp", "image/gif"]
    unless acceptable_types.include?(image.blob.content_type)
      errors.add(:image, "は JPEG/PNG/WebP/GIF を選んでください")
    end
  end
end
