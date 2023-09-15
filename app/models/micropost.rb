# frozen_string_literal: true

class Micropost < ApplicationRecord
  CONTENT_LENTH_MAX = 150
  IMG_SIZE_MG_MAX = 5

  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  # default_scope: (*It seems it's no good to use it!) https://techracho.bpsinc.jp/hachi8833/2021_11_04/47302
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: CONTENT_LENTH_MAX }

  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: IMG_SIZE_MG_MAX.megabytes,
                            message: "should be less than #{IMG_SIZE_MG_MAX}MB" }
end
