# リプライ先のユーザーが存在することを検証する
class ReplyToUserValidator < ActiveModel::EachValidator
  # @param record [ActiveRecord::Base] 検証対象のレコード
  # @param attr_name [Symbol] 検証する属性名
  # @param value [Integer, nil] 検証する値（ユーザーID）
  # @return [void]
  def validate_each(record, attr_name, value)
    return if value.nil?

    unless User.find_by(id: value)
      record.errors.add(attr_name, options[:message] || :user_not_found)
    end
  end
end

