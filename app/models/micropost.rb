class Micropost < ApplicationRecord
  CONTENT_LENTH_MAX = 150

  belongs_to :user
  # default_scope: (*It seems it's no good to use it!) https://techracho.bpsinc.jp/hachi8833/2021_11_04/47302
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: CONTENT_LENTH_MAX }

end
