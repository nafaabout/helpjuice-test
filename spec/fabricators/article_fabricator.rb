# frozen_string_literal: true

Fabricator(:article) do
  title { Faker::Book.title }
end
