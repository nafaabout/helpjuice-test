# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[guest admin]

  has_many :searches

  validates :username, :password, presence: true, if: :admin?
end
