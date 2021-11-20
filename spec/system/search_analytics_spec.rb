# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SearchAnalytics', type: :system do
  let(:users) { Fabricate.times(3, :user) }
  let!(:complete_searches) { users.map{ Fabricate.times(2, :search, status: :complete, user: _1) }.flatten }
  let!(:incomplete_searches) { Fabricate.times(2, :search, status: :incomplete, user: users.sample) }

  before do
    driven_by(:rack_test)
  end

  specify 'display all complete user searches' do
    visit searches_path

    complete_searches.each do |search|
      expect(page).to have_selector('#searches .search', text: search.query)
    end
  end

  specify 'do not display incomplete searches' do
    visit root_path
    click_on 'Searches'

    incomplete_searches.each do |search|
      expect(page).to_not have_selector('#searches .search', text: search.query)
    end
  end
end
