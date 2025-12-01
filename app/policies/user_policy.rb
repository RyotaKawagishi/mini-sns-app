# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # @return [Boolean] ユーザー一覧を表示できるか
  def index?
    user.present?
  end

  # @return [Boolean] ユーザー詳細を表示できるか
  def show?
    record.activated?
  end

  # @return [Boolean] ユーザーを作成できるか
  def create?
    true
  end

  # @return [Boolean] ユーザーを更新できるか
  def update?
    user.present? && user == record
  end

  # @return [Boolean] ユーザーを削除できるか
  def destroy?
    user.present? && user.admin?
  end

  # @return [Boolean] フォロー中一覧を表示できるか
  def following?
    user.present?
  end

  # @return [Boolean] フォロワー一覧を表示できるか
  def followers?
    user.present?
  end

  class Scope < Scope
    # @return [ActiveRecord::Relation] スコープに基づくユーザー一覧
    def resolve
      scope.where(activated: true)
    end
  end
end

