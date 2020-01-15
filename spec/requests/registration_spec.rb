# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe 'GET' do
    it '#new assigns a new class' do
      get new_user_registration_path
      expect(assigns(:user)).to be_a_new(User)
    end

    it '#otp_setup' do
      @db_user = FactoryBot.attributes_for(:db_user)
      get otp_registration_path(Base64.encode64(@db_user[:email])), xhr: true
      expect(current_path).to render_template(:otp_setup)
      expect(response.body).to include('shape-rendering=')
    end
  end

  describe 'POST' do
    context 'valid attributes' do
      it 'redirects to new session page on successful registration' do
        @db_user = FactoryBot.attributes_for(:db_user)
        post user_registration_path, params: {user: @db_user}
        expect(current_path).to redirect_to(new_user_session_path)
        u = User.find_by_email(@db_user[:email])
        expect(u.otp_required_for_login?).to be_truthy
      end
    end

    context 'invalid attributes' do
      it 'renders the new page' do
        @db_user = FactoryBot.attributes_for(:db_user, password_confirmation: 'testing!')
        expect do
          post user_registration_path, params: {user: @db_user}
        end.not_to change { User.count }
        expect(current_path).to render_template(:new)
        expect(response.body).to include('Passwords do not match')
      end
    end
  end
end