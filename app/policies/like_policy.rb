# frozen_string_literal: true

class LikePolicy < ApplicationPolicy
  # @return [Boolean]
  def create?
    user.present? && user.activated? && record.user_id == user.id && record.micropost.user.activated?
  end

  # @return [Boolean]
  def destroy?
    user.present? && record.user_id == user.id
  end
end
