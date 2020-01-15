# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  before(:each) do
    # OmniAuth.config.mock_auth[:google_oauth2] = nil
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    # User.find_by_email('john@example.com') || FactoryBot.create(:user)
  end

  after(:each) do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      "provider" => "google_oauth2",
      "uid" => "100000000000000000000",
      "info" => {
        "name" => "John Smith",
        "email" => "john@example.com",
        "first_name" => "John",
        "last_name" => "Smith",
        "image" => "https://lh4.googleusercontent.com/photo.jpg",
        "urls" => {
          "google" => "https://plus.google.com/+JohnSmith"
        }
      },
      "credentials" => {
        "token" => "TOKEN",
        "refresh_token" => "REFRESH_TOKEN",
        "expires_at" => 1496120719,
        "expires" => true
      },
      "extra" => {
        "id_token" => "ID_TOKEN",
        "id_info" => {
          "azp" => "APP_ID",
          "aud" => "APP_ID",
          "sub" => "100000000000000000000",
          "email" => "john@example.com",
          "email_verified" => true,
          "at_hash" => "HK6E_P6Dh8Y93mRNtsDB1Q",
          "iss" => "accounts.google.com",
          "iat" => 1496117119,
          "exp" => 1496120719
        },
        "raw_info" => {
          "sub" => "100000000000000000000",
          "name" => "John Smith",
          "given_name" => "John",
          "family_name" => "Smith",
          "profile" => "https://plus.google.com/+JohnSmith",
          "picture" => "https://lh4.googleusercontent.com/photo.jpg?sz=50",
          "email" => "john@example.com",
          "email_verified" => "true",
          "locale" => "en",
          "hd" => "company.com"
        }
      }
    })
  end

  describe 'GET' do
    it 'redirects to google' do
      get user_google_oauth2_omniauth_authorize_path
      expect(current_path).to redirect_to(user_google_oauth2_omniauth_callback_path)
    end

    it 'runs the callback and redirects to the dashboard' do
      get user_google_oauth2_omniauth_callback_path
      User.find_by_email('john@example.com').update!(approved: true)
      get user_google_oauth2_omniauth_callback_path
      expect(current_path).to redirect_to(dashboard_path)
    end

    it 'runs the callback and fails to authenticate' do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      get user_google_oauth2_omniauth_callback_path
      expect(current_path).to redirect_to(new_user_session_path)
    end

    it 'handles google oauth2 problems gracefully' do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        'provider' => 'google_oauth2',
        'uid' => '100000000000000000000',
        'info' => {
          'name' => 'John Smith',
          'email' => nil,
          'first_name' => 'John',
          'last_name' => 'Smith',
          'image' => 'https://lh4.googleusercontent.com/photo.jpg',
          'urls' => {
            'google' => 'https://plus.google.com/+JohnSmith'
          }
        },
        'credentials' => {
          'token' => 'TOKEN',
          'refresh_token' => 'REFRESH_TOKEN',
          'expires_at' => 1_496_120_719,
          'expires' => true
        },
        'extra' => {
          'id_token' => 'ID_TOKEN',
          'id_info' => {
            'azp' => 'APP_ID',
            'aud' => 'APP_ID',
            'sub' => '100000000000000000000',
            'email' => nil,
            'email_verified' => true,
            'at_hash' => 'HK6E_P6Dh8Y93mRNtsDB1Q',
            'iss' => 'accounts.google.com',
            'iat' => 1_496_117_119,
            'exp' => 1_496_120_719
          },
          'raw_info' => {
            'sub' => '100000000000000000000',
            'name' => 'John Smith',
            'given_name' => 'John',
            'family_name' => 'Smith',
            'profile' => 'https://plus.google.com/+JohnSmith',
            'picture' => 'https://lh4.googleusercontent.com/photo.jpg?sz=50',
            'email' => nil,
            'email_verified' => 'true',
            'locale' => 'en',
            'hd' => 'company.com'
          }
        }
      )
      get user_google_oauth2_omniauth_callback_path
      expect(current_path).to redirect_to(new_user_session_path)
    end
  end
end