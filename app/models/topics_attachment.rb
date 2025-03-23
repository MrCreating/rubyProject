class TopicsAttachment < ApplicationRecord
  belongs_to :topic
  belongs_to :attachment
end