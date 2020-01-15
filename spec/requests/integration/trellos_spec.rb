# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Integration::Trellos', type: :request do
  describe 'default denies access to trellos', type: :request do
    it do
      get new_integration_trello_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'factory' do
    it 'is valid' do
      @integration_trello = FactoryBot.create(:integration_trello)
      expect(@integration_trello).to be_valid
    end
  end

  describe 'GET' do
    before(:each) do
      login_user
    end

    it '#index' do
      get integration_trellos_path
      expect(response).to render_template(:index)
    end

    it '#new assigns a new class' do
      get new_integration_trello_path
      expect(assigns(:trello)).to be_a_new(Integration::Trello)
    end

    it '#edit' do
      @integration_trello = FactoryBot.create(:integration_trello)
      get edit_integration_trello_path(@integration_trello)
      expect(response).to render_template(:edit)
    end

    it '#edit assigns class appropriately' do
      @integration_trello = FactoryBot.create(:integration_trello)
      get edit_integration_trello_path(@integration_trello)
      expect(assigns(:trello)).to eq(@integration_trello)
    end

    it '#show creates a test card' do
      @integration_trello = FactoryBot.create(:integration_trello)
      get integration_trello_path(@integration_trello)
      expect(current_path).to redirect_to(integration_trellos_path)
    end
  end

  describe 'POST' do
    before(:each) do
      login_user
      @integration_trello = FactoryBot.attributes_for(:integration_trello)
    end

    context 'valid attributes' do
      it 'redirects to index page' do
        post integration_trellos_path, params: {integration_trello: @integration_trello}
        expect(current_path).to redirect_to(integration_trellos_path)
      end

      it 'expects the count to increase by 1' do
        expect do
          post integration_trellos_path, params: {integration_trello: @integration_trello}
        end.to change(Integration::Trello, :count).by(1)
      end
    end

    context 'invalid attributes' do
      it 'does not create the model' do
        expect do
          post integration_trellos_path, params: {integration_trello: FactoryBot.attributes_for(:invalid_integration_trello)}
        end.not_to change { Integration::Trello.count }
      end
    end
  end

  describe 'PUT' do
    before(:each) do
      login_user
      @integration_trello = FactoryBot.create(:integration_trello)
    end

    context 'valid attributes' do
      it 'located the model' do
        put integration_trello_path(@integration_trello), params: {integration_trello: FactoryBot.attributes_for(:integration_trello)}
        expect(assigns(:trello)).to eq @integration_trello
      end

      it 'changes attributes' do
        put integration_trello_path(@integration_trello),
            params: {
              integration_trello: FactoryBot.attributes_for(
                :integration_trello,
                name: 'My New Name'
              )
            }
        @integration_trello.reload
        expect(@integration_trello.name).to eq('My New Name')
      end

      it 'redirects to the index method' do
        put integration_trello_path(@integration_trello), params: {integration_trello: FactoryBot.attributes_for(:integration_trello)}
        expect(current_path).to redirect_to(integration_trellos_path)
      end
    end

    context 'invalid attributes' do
      it 'does not modify the model' do
        put integration_trello_path(@integration_trello), params: {integration_trello: FactoryBot.attributes_for(:invalid_integration_trello)}
        expect(assigns(:trello)).to eq @integration_trello
      end

      it 're-renders the edit template' do
        put integration_trello_path(@integration_trello), params: {integration_trello: FactoryBot.attributes_for(:invalid_integration_trello)}
        expect(current_path).to render_template(:edit)
      end

      it 'rejects an invalid attribute' do
        put integration_trello_path(@integration_trello),
            params: {integration_trello: FactoryBot.attributes_for(
              :integration_trello, name: 'My New Name', token: ' '
            )}
        @integration_trello.reload
        expect(@integration_trello.name).to eq('My New Name')
        expect(@integration_trello.token).to_not eq ' '
      end
    end
  end

  describe 'DELETE' do
    before(:each) do
      login_user
      @integration_trello = FactoryBot.create(:integration_trello)
    end

    it 'deletes the model' do
      expect do
        delete integration_trello_path(@integration_trello)
      end.to change(Integration::Trello, :count).by(-1)
    end

    it 'redirects to the index method' do
      delete integration_trello_path(@integration_trello)
      expect(current_path).to redirect_to(integration_trellos_path)
    end
  end
end