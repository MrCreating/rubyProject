class Topic < ApplicationRecord
  validates :title, presence: true, length: { maximum: 96 }
  validates :description, length: { maximum: 4096 }, allow_blank: true
  validates :user_id, presence: true
end