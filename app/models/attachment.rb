class Attachment < ApplicationRecord
  belongs_to :user

  self.inheritance_column = nil

  has_one_attached :file

  def credentials
    "photo#{self.user.id}_#{self.id}_#{self.access_key}"
  end

  def self.find_by_photo(photo: String)
    return nil if photo == ''
    return nil unless photo.is_a?(String) && !photo.empty?

    match_data = photo.match(/^photo(?<owner_id>\d+)_(?<attachment_id>\d+)_(?<access_key>[a-zA-Z0-9]+)$/)
    return nil unless match_data

    find_by(
      id: match_data[:attachment_id],
      user_id: match_data[:owner_id],
      access_key: match_data[:access_key]
    )
  end
end
