# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SearchAnalytics', type: :system do
  let!(:user) { Fabricate(:user, role: user_role) }

  before do
    driven_by(:rack_test)
    allow_any_instance_of(SearchesController).to receive(:current_user).and_return(user)
  end

  context 'When user is a guest' do
    let!(:user_role) { :guest }
    let!(:user_searches) { Fabricate.times(2, :search, user: user, status: :complete) }
    let!(:incomplete_user_searches) { Fabricate.times(2, :search, user: user, status: :incomplete) }
    let!(:other_searches) { Fabricate.times(2, :search, status: :complete) }

    it 'can only see his own searches' do
      visit root_path
      click_on 'Searches'

      user_searches.each do |search|
        expect(page).to have_text(search.query)
      end

      other_searches.each do |search|
        expect(page).to_not have_text(search.query)
      end
    end

    it 'can only see complete searches' do
      visit root_path
      click_on 'Searches'

      incomplete_user_searches.each do |search|
        expect(page).to_not have_text(search.query)
      end
    end
  end

  context 'When user is an admin' do
    let!(:user_role) { :admin }
    let!(:complete_searches) { Fabricate.times(5, :search, status: :complete) }
    let!(:incomplete_searches) { Fabricate.times(5, :search, status: :incomplete) }

    it 'can see all complete searches' do
      visit root_path
      click_on 'Searches'

      complete_searches.each do |search|
        expect(page).to have_text(search.query)
      end
    end

    it 'cannot see incomplete searches' do
      visit root_path
      click_on 'Searches'

      incomplete_searches.each do |search|
        expect(page).to_not have_text(search.query)
      end
    end
  end
end
