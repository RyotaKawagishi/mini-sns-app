class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [250, 250]
  end
  default_scope -> { order(created_at: :desc) }
  before_validation :set_in_reply_to

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
  validate :reply_to_user

  def self.including_replies(id)
    where(in_reply_to: [id, nil])
  end

  def set_in_reply_to
    return self.in_reply_to = nil unless content
  
    # @数字-ユーザー名 の形式だけに反応するように修正
    if content.match?(/\A@(\d+)-[\w\-]+/)
      id_part = content.match(/\A@(\d+)-/)[1]
      self.in_reply_to = id_part.to_i
    else
      self.in_reply_to = nil
    end
  end

  def reply_to_user
    return if self.in_reply_to.nil?
    unless user = User.find_by(id: self.in_reply_to)
            errors.add(:base, "User ID you specified doesn't exist.")
    else
        if user_id == self.in_reply_to
            errors.add(:base, "You can't reply to yourself.")
        else
            unless reply_to_user_name_correct?(user)
                errors.add(:base, "User ID doesn't match its name.")
            end
        end
    end
  end

  def reply_to_user_name_correct?(user)
    return false unless content && in_reply_to
  
    expected = user.name.gsub(" ", "-")
    pattern = "@#{in_reply_to}-#{expected}"
    content.include?(pattern)
  end

  private
    def is_i?(s)
        !!Integer(s) rescue false
    end

end
