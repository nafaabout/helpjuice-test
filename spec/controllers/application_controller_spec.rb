# frozen_string_literal: true

require 'rails_helper'

class SomeController < ApplicationController; end

RSpec.describe ApplicationController, type: :controller do
  controller SomeController do
    def index
      render plain: 'Rendered'
    end
  end

  describe 'Guest User' do
    context 'when the user did not visit the site before' do
      before do
        cookies[:user_id] = nil
      end

      it 'creates new guest user' do
        expect { get :index }.to change(User, :count).by(1)
      end

      it 'sets cookies[:user_id] to the created user' do
        get :index

        expect(cookies[:user_id].to_i).to eq(User.first.id)
      end
    end

    context 'when the user has visited the site before' do
      before do
        cookies[:user_id] = 1
      end

      it 'does not create a new user' do
        expect { get :index }.to_not change(User, :count)
      end

      it 'does not change cookies[:user_id]' do
        get :index
        expect(cookies[:user_id].to_i).to eq 1
      end
    end
  end
end
