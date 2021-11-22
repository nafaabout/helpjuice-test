# frozen_string_literal: true

class Search < ApplicationRecord
  scope :of_user, ->(user) { where(user: user) }

  belongs_to :user
  enum status: %i[incomplete complete]
end
