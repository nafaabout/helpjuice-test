# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersSessions', type: :system do
  let!(:user) { Fabricate(:user, username: 'admin', password: '12345', role: :admin) }

  before do
    driven_by(:rack_test)
  end

  def log_user_in(username, password)
    visit root_path
    click_on 'Login'

    fill_in 'user[username]', with: username
    fill_in 'user[password]', with: password

    click_button 'Login'
  end

  describe 'User login' do
    context 'When login succeeds' do
      it 'redirects to root page and shows Logout link' do
        log_user_in(user.username, user.password)

        expect(page).to have_content('Admin')
        expect(page).to have_link(href: logout_path)
      end
    end

    context 'When login fails' do
      it 'shows error "Wrong username or password"' do
        log_user_in(user.username, 'wrong password')

        expect(page).to have_selector('input[name=username]')
        expect(page).to have_selector('input[name=password]')
        expect(page).to have_text('Wrong username or password')
      end
    end
  end

  describe 'User logout' do
    it 'redirects to root page and show login link' do
      log_user_in(user.username, user.password)

      click_link href: logout_path

      expect(page).to have_selector('a', text: 'Login')
      expect(page.current_path).to eq root_path
    end
  end
end
