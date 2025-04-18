class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :reply_to_user, class_name: "User", foreign_key: "in_reply_to", optional: true

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [250, 250]
  end
  default_scope -> { order(created_at: :desc) }

  # before_validation :prepend_mention_to_content, if: :in_reply_to?
  # before_validation :set_in_reply_to


  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
  validate :validate_reply_to_user
  validate :cannot_reply_to_self


  # コンテンツ中にメンションがあれば、in_reply_toをセットする（フォームにしたので現在不要）
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

  # ユーザーがメンションを正しく指定しているか確認する
  def validate_reply_to_user
    return if self.in_reply_to.nil?
    unless user = User.find_by(id: self.in_reply_to)
            errors.add(:base, "User ID you specified doesn't exist.")
    else
        if user_id == self.in_reply_to
            errors.add(:base, "You can't reply to yourself.")
        end
    end
  end


  private

    # メンションをコンテンツの一行目に追加する（現在不要）
    def prepend_mention_to_content
      return unless in_reply_to.present?
      user_to_mention = User.find_by(id: in_reply_to)
      return unless user_to_mention
      mention = "@#{user_to_mention.id}-#{user_to_mention.name.gsub(" ", "-")}"
      self.content = "#{mention} #{content}" #unless content.include?(mention)
    end

    # ユーザーが自分自身にメンションできないようにする
    def cannot_reply_to_self
      return unless user && in_reply_to == user.id
      errors.add(:in_reply_to, "You can't reply to yourself.")
    end

end
