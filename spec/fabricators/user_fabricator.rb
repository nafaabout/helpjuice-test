# frozen_string_literal: true

Fabricator(:user) do
  is_guest { [true, false].sample }
end
