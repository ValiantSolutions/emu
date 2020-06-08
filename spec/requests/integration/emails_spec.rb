# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Integration::Emails', type: :request do
  describe 'default denies access to slacks', type: :request do
    it do
      get new_integration_email_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'factory' do
    it 'is valid' do
      @integration_email = FactoryBot.create(:integration_email)
      expect(@integration_email).to be_valid
    end
  end

  describe 'GET' do
    before(:each) do
      login_admin
    end

    it '#index' do
      get integration_emails_path
      expect(response).to render_template(:index)
    end

    it '#new assigns a new class' do
      get new_integration_email_path
      expect(assigns(:email)).to be_a_new(Integration::Email)
    end

    it '#edit' do
      @integration_email = FactoryBot.create(:integration_email)
      get edit_integration_email_path(@integration_email)
      expect(response).to render_template(:edit)
    end

    it '#edit assigns class appropriately' do
      @integration_email = FactoryBot.create(:integration_email)
      get edit_integration_email_path(@integration_email)
      expect(assigns(:email)).to eq(@integration_email)
    end

    # it '#show sends a test message' do
    #   @integration_email = FactoryBot.create(:integration_email)
    #   get integration_email_path(@integration_email)
    #   expect(current_path).to redirect_to(integration_emails_path)
    # end
  end

  describe 'POST' do
    before(:each) do
      login_admin
      @integration_email = FactoryBot.attributes_for(:integration_email)
    end

    context 'valid attributes' do
      it 'redirects to index page' do
        post integration_emails_path, params: {integration_email: @integration_email}
        expect(current_path).to redirect_to(integration_emails_path)
      end

      it 'expects the count to increase by 1' do
        expect do
          post integration_emails_path, params: {integration_email: @integration_email}
        end.to change(Integration::Email, :count).by(1)
      end
    end

    context 'invalid attributes' do
      it 'does not create the model' do
        expect do
          post integration_emails_path, params: {integration_email: FactoryBot.attributes_for(:invalid_integration_email)}
        end.not_to change { Integration::Email.count }
      end
    end
  end

  describe 'PUT' do
    before(:each) do
      login_admin
      @integration_email = FactoryBot.create(:integration_email)
    end

    context 'valid attributes' do
      it 'located the model' do
        put integration_email_path(@integration_email), params: {integration_email: FactoryBot.attributes_for(:integration_email)}
        expect(assigns(:email)).to eq @integration_email
      end

      it 'changes attributes' do
        put integration_email_path(@integration_email),
            params: {
              integration_email: FactoryBot.attributes_for(
                :integration_email,
                name: 'My New Name'
              )
            }
        @integration_email.reload
        expect(@integration_email.name).to eq('My New Name')
      end

      it 'redirects to the index method' do
        put integration_email_path(@integration_email), params: {integration_email: FactoryBot.attributes_for(:integration_email)}
        expect(current_path).to redirect_to(integration_emails_path)
      end
    end

    context 'invalid attributes' do
      it 'does not modify the model' do
        put integration_email_path(@integration_email), params: {integration_email: FactoryBot.attributes_for(:invalid_integration_email)}
        expect(assigns(:email)).to eq @integration_email
      end

      it 're-renders the edit template' do
        put integration_email_path(@integration_email), params: {integration_email: FactoryBot.attributes_for(:invalid_integration_email)}
        expect(current_path).to render_template(:edit)
      end

      it 'rejects an invalid attribute' do
        put integration_email_path(@integration_email),
            params: {integration_email: FactoryBot.attributes_for(
              :integration_email, name: 'My New Name 123', host: ''
            )}
        @integration_email.reload
        expect(@integration_email.name).to_not eq('My New Name 123')
        expect(@integration_email.host).to_not eq ''
      end
    end
  end

  describe 'DELETE' do
    before(:each) do
      login_admin
      @integration_email = FactoryBot.create(:integration_email)
    end

    it 'deletes the model' do
      expect do
        delete integration_email_path(@integration_email)
      end.to change(Integration::Email, :count).by(-1)
    end

    it 'redirects to the index method' do
      delete integration_email_path(@integration_email)
      expect(current_path).to redirect_to(integration_emails_path)
    end
  end
end