# frozen_string_literal: true

class MicropostPolicy < ApplicationPolicy
  # @return [Boolean] マイクロポストを作成できるか
  def create?
    user.present?
  end

  # @return [Boolean] マイクロポストを削除できるか
  def destroy?
    user.present? && user == record.user
  end

  class Scope < Scope
    # @return [ActiveRecord::Relation] スコープに基づくマイクロポスト一覧
    def resolve
      scope.all
    end
  end
end

