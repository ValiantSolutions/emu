# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  describe 'GET' do
    it '#new assigns a new class' do
      get new_user_session_path
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST' do
    context 'valid attributes' do
      it 'redirects to dashboard page on successful authentication' do
        FactoryBot.create(:db_user)
        post user_session_path, params: {user: {email: 'mydb@user.com', password: 'testing123!'}}
        expect(current_path).to redirect_to(dashboard_path)
      end
    end
    
    context 'invalid attributes' do
      it 'renders the new page' do
        FactoryBot.create(:db_user)
        post user_session_path, params: {user: {email: 'mydb@user.com', password: '1234testing!'}}
        expect(current_path).to render_template(:new)
        expect(response.body).to include('error')
      end
    end
  end
end