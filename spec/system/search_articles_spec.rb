# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search Articles', type: :system do
  before do
    driven_by(:selenium)
  end

  it 'shows a search input on the root page' do
    visit root_path

    expect(page).to have_selector('#search-form input[type=text]#query')
  end

  context 'when user types a search query' do
    let!(:articles) { matched_articles + non_matched_articles }
    let!(:matched_articles) { Fabricate.times(2, :article, title: Faker::Book.title) }
    let!(:non_matched_articles) { Fabricate.times(2, :article) }
    let(:query) { matched_articles.first.title.slice(0..10) }

    it 'shows the matched articles', js: true do
      visit root_path

      within('#search-form') do
        fill_in('query', with: query)
      end

      matched_articles.each do |article|
        expect(page).to have_selector('#articles .article', text: article.title)
      end

      non_matched_articles.each do |article|
        expect(page).to_not have_selector('#articles .article', text: article.title)
      end
    end
  end
end
