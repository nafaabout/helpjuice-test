# frozen_string_literal: true

Fabricator(:user) do
  username { Faker::Internet.username }
  password { Faker::Internet.password }
  role :guest
end
