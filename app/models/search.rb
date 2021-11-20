# frozen_string_literal: true

class Search < ApplicationRecord
  scope :of_user, ->(user) { where(user: user) }

  belongs_to :user
  enum status: %i[incomplete complete]

  def updated_since?(time)
    raise ArgumentError, ':time must be an ActiveSupport::TimeWithZone' unless time.is_a?(ActiveSupport::TimeWithZone)

    updated_at > time
  end
end
