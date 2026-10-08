# frozen_string_literal: true

class Search
  include ActiveModel::Model

  attr_accessor :query, :author_id, :from_date, :to_date

  validate :valid_date_range

  # @param scope [ActiveRecord::Relation]
  # @param admin [Boolean]
  # @return [ActiveRecord::Relation]
  def users(scope, admin: false)
    return scope.order(:name, :id) if query.blank?

    condition = "LOWER(name) LIKE LOWER(:query) ESCAPE '!'"
    condition += " OR LOWER(email) LIKE LOWER(:query) ESCAPE '!'" if admin
    scope.where(condition, query: query_pattern).order(:name, :id)
  end

  # @param scope [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation]
  def microposts(scope)
    return scope.none unless valid?

    scope = scope.where("LOWER(content) LIKE LOWER(?) ESCAPE '!'", query_pattern) if query.present?
    scope = scope.where(user_id: author_id) if author_id.present?
    scope = filter_dates(scope)
    scope.reorder(created_at: :desc, id: :desc).includes(:user, :likes, image_attachment: :blob)
  end

  private

  # @return [String]
  def query_pattern
    "%#{ActiveRecord::Base.sanitize_sql_like(query.strip, '!')}%"
  end

  # @param scope [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation]
  def filter_dates(scope)
    scope = scope.where(microposts: { created_at: Date.iso8601(from_date).in_time_zone.. }) if from_date.present?
    scope = scope.where(microposts: { created_at: ...Date.iso8601(to_date).next_day.in_time_zone }) if to_date.present?
    scope
  end

  # @return [void]
  def valid_date_range
    start_date = Date.iso8601(from_date) if from_date.present?
    end_date = Date.iso8601(to_date) if to_date.present?
    errors.add(:base, 'Start date must be on or before end date.') if start_date && end_date && start_date > end_date
  rescue ArgumentError, TypeError
    errors.add(:base, 'Please enter a valid date.')
  end
end
