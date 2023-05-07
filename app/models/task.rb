class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum priority: { High: 0, Middle: 1, Low: 2 }

  scope :sort_expired_at, -> {order(expired_at: :desc)}
  scope :sort_priority, -> { order(priority: :asc) }
  
end
