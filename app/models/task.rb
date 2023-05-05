class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true

  scope :sort_expired_at, -> {order(expired_at: :desc)}
end
