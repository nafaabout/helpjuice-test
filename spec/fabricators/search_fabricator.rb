# frozen_string_literal: true

Fabricator(:search) do
  query      { Faker::Book.title }
  status     { Search.statuses.values.sample }
  user
end
