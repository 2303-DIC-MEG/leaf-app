class Task < ApplicationRecord
  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum priority: { High: 0, Middle: 1, Low: 2 }

  scope :title_search, -> (title){where('title LIKE ?', "%#{title}%")}
  scope :status_search, -> (status){where('status LIKE ?', "#{status}")}
  scope :label_search, -> (label_id){ where(id: Labelling.where(label_id: label_id).pluck(:task_id))}

  scope :sort_expired_at, -> {order(expired_at: :desc)}
  scope :sort_priority, -> { order(priority: :asc) }
  
end
