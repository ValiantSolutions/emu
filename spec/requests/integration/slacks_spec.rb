# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Integration::Slacks', type: :request do
  describe 'default denies access to slacks', type: :request do
    it do
      get new_integration_slack_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'factory' do
    it 'is valid' do
      @integration_slack = FactoryBot.create(:integration_slack)
      expect(@integration_slack).to be_valid
    end
  end

  describe 'GET' do
    before(:each) do
      login_admin
    end

    it '#index' do
      get integration_slacks_path
      expect(response).to render_template(:index)
    end

    it '#new assigns a new class' do
      get new_integration_slack_path
      expect(assigns(:slack)).to be_a_new(Integration::Slack)
    end

    it '#edit' do
      @integration_slack = FactoryBot.create(:integration_slack)
      get edit_integration_slack_path(@integration_slack)
      expect(response).to render_template(:edit)
    end

    it '#edit assigns class appropriately' do
      @integration_slack = FactoryBot.create(:integration_slack)
      get edit_integration_slack_path(@integration_slack)
      expect(assigns(:slack)).to eq(@integration_slack)
    end

    it '#show sends a test message' do
      @integration_slack = FactoryBot.create(:integration_slack)
      #expect do
      get integration_slack_path(@integration_slack)
      #end.to raise_error(Slack::Web::Api::Errors::SlackError)
      expect(current_path).to redirect_to(integration_slacks_path)
    end
  end

  describe 'POST' do
    before(:each) do
      login_admin
      @integration_slack = FactoryBot.attributes_for(:integration_slack)
    end

    context 'valid attributes' do
      it 'redirects to index page' do
        post integration_slacks_path, params: {integration_slack: @integration_slack}
        expect(current_path).to redirect_to(integration_slacks_path)
      end

      it 'expects the count to increase by 1' do
        expect do
          post integration_slacks_path, params: {integration_slack: @integration_slack}
        end.to change(Integration::Slack, :count).by(1)
      end
    end

    context 'invalid attributes' do
      it 'does not create the model' do
        expect do
          post integration_slacks_path, params: {integration_slack: FactoryBot.attributes_for(:invalid_integration_slack)}
        end.not_to change { Integration::Slack.count }
      end
    end
  end

  describe 'PUT' do
    before(:each) do
      login_admin
      @integration_slack = FactoryBot.create(:integration_slack)
    end

    context 'valid attributes' do
      it 'located the model' do
        put integration_slack_path(@integration_slack), params: {integration_slack: FactoryBot.attributes_for(:integration_slack)}
        expect(assigns(:slack)).to eq @integration_slack
      end

      it 'changes attributes' do
        put integration_slack_path(@integration_slack),
            params: {
              integration_slack: FactoryBot.attributes_for(
                :integration_slack,
                name: 'My New Name'
              )
            }
        @integration_slack.reload
        expect(@integration_slack.name).to eq('My New Name')
      end

      it 'redirects to the index method' do
        put integration_slack_path(@integration_slack), params: {integration_slack: FactoryBot.attributes_for(:integration_slack)}
        expect(current_path).to redirect_to(integration_slacks_path)
      end
    end

    context 'invalid attributes' do
      it 'does not modify the model' do
        put integration_slack_path(@integration_slack), params: {integration_slack: FactoryBot.attributes_for(:invalid_integration_slack)}
        expect(assigns(:slack)).to eq @integration_slack
      end

      it 're-renders the edit template' do
        put integration_slack_path(@integration_slack), params: {integration_slack: FactoryBot.attributes_for(:invalid_integration_slack)}
        expect(current_path).to render_template(:edit)
      end

      it 'rejects an invalid attribute' do
        put integration_slack_path(@integration_slack),
            params: {integration_slack: FactoryBot.attributes_for(
              :integration_slack, name: 'My New Name 123', secret: ' '
            )}
        @integration_slack.reload
        expect(@integration_slack.name).to eq('My New Name 123')
        expect(@integration_slack.secret).to_not eq ' '
      end
    end
  end

  describe 'DELETE' do
    before(:each) do
      login_admin
      @integration_slack = FactoryBot.create(:integration_slack)
    end

    it 'deletes the model' do
      expect do
        delete integration_slack_path(@integration_slack)
      end.to change(Integration::Slack, :count).by(-1)
    end

    it 'redirects to the index method' do
      delete integration_slack_path(@integration_slack)
      expect(current_path).to redirect_to(integration_slacks_path)
    end
  end
end