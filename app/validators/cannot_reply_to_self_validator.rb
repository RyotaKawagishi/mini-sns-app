# 自分自身にリプライできないことを検証する
class CannotReplyToSelfValidator < ActiveModel::EachValidator
  # @param record [ActiveRecord::Base] 検証対象のレコード
  # @param attr_name [Symbol] 検証する属性名
  # @param value [Integer, nil] 検証する値（ユーザーID）
  # @return [void]
  def validate_each(record, attr_name, value)
    return if value.nil?
    return unless record.respond_to?(:user_id) && record.user_id

    if record.user_id == value
      record.errors.add(attr_name, options[:message] || :cannot_reply_to_self)
    end
  end
end

