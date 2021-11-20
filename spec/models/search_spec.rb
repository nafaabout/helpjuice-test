# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '#updated_since?' do
    context 'when the search is updated after the given time' do
      it 'returns true' do
        search = Fabricate(:search, created_at: 3.seconds.ago, updated_at: 3.seconds.ago)
        expect(search.updated_since?(4.seconds.ago)).to be true
      end
    end

    context 'when the search is not updated after the given time' do
      it 'returns false' do
        search = Fabricate(:search, created_at: 5.seconds.ago, updated_at: 5.seconds.ago)
        expect(search.updated_since?(4.seconds.ago)).to be false
      end
    end
  end
end
