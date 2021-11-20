# frozen_string_literal: true

Fabricator(:search) do
  query      { Faker::Book.title }
  status     :incomplete
  user
end
