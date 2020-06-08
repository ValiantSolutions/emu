# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElasticEndpointsController, type: :request do
  describe 'default denies access to elastic_endpoint', type: :request do
    it do
      get new_elastic_endpoint_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'GET' do
    before(:each) do
      login_admin
    end

    it '#index' do
      get elastic_endpoints_path
      expect(response).to render_template(:index)
    end

    it '#new' do
      get new_elastic_endpoint_path
      expect(response).to render_template(:new)
    end

    it '#new assigns a new class' do
      get new_elastic_endpoint_path
      expect(assigns(:elastic_endpoint)).to be_a_new(ElasticEndpoint)
    end

    it '#edit' do
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint)
      get edit_elastic_endpoint_path(@elastic_endpoint)
      expect(response).to render_template(:edit)
    end

    it '#edit assigns class appropriately' do
      elastic_endpoint = FactoryBot.create(:elastic_endpoint)
      get edit_elastic_endpoint_path(elastic_endpoint)
      expect(assigns(:elastic_endpoint)).to eq(elastic_endpoint)
    end
  end

  describe 'POST' do
    before(:each) do
      login_admin
      @elastic_endpoint = FactoryBot.attributes_for(:elastic_endpoint)
    end

    context 'valid attributes' do
      it 'redirects to index page' do
        post elastic_endpoints_path, params: {elastic_endpoint: @elastic_endpoint}
        expect(current_path).to redirect_to(elastic_endpoints_path)
      end

      it 'expects the count to increase by 1' do
        expect do
          post elastic_endpoints_path, params: {elastic_endpoint: @elastic_endpoint}
        end.to change(ElasticEndpoint, :count).by(1)
      end

      it 'cleans the address' do
        elastic_endpoint = FactoryBot.attributes_for(:elastic_endpoint, address: 'http://copy-pasted-value.com:9999')
        post elastic_endpoints_path, params: {elastic_endpoint: elastic_endpoint}
        expect(assigns(:elastic_endpoint).address).to eq('copy-pasted-value.com')
      end
    end

    context 'invalid attributes' do
      it 'does not create the model' do
        expect do
          post elastic_endpoints_path, params: {elastic_endpoint: FactoryBot.attributes_for(:invalid_elastic_endpoint)}
        end.not_to change { ElasticEndpoint.count }
      end
    end
  end

  describe 'PUT' do
    before(:each) do
      login_admin
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint)
    end

    context 'valid attributes' do
      it 'located the model' do
        put elastic_endpoint_path(@elastic_endpoint), params: {elastic_endpoint: FactoryBot.attributes_for(:elastic_endpoint)}
        expect(assigns(:elastic_endpoint)).to eq @elastic_endpoint
      end

      it 'changes attributes without updating the password' do
        put elastic_endpoint_path(@elastic_endpoint),
            params: {elastic_endpoint: FactoryBot.attributes_for(
              :elastic_endpoint, name: 'My New Name', username: 'my_new_user', password: ' '
            )}
        @elastic_endpoint.reload
        expect(@elastic_endpoint.name).to eq('My New Name')
        expect(@elastic_endpoint.username).to eq('my_new_user')
        expect(@elastic_endpoint.username).to_not eq(' ')
      end

      it 'cleans the address' do
        put elastic_endpoint_path(@elastic_endpoint),
            params: {elastic_endpoint: FactoryBot.attributes_for(
              :elastic_endpoint, address: 'http://copy-pasted-value.com:9999'
            )}
        @elastic_endpoint.reload
        expect(@elastic_endpoint.address).to eq('copy-pasted-value.com')
      end

      it 'changes attributes and updates password' do
        put elastic_endpoint_path(@elastic_endpoint),
            params: {
              elastic_endpoint: FactoryBot.attributes_for(
                :elastic_endpoint,
                name: 'My New Name',
                password: 'my_new_password',
                username: 'my_new_user'
              )
            }
        @elastic_endpoint.reload
        expect(@elastic_endpoint.name).to eq('My New Name')
        expect(@elastic_endpoint.username).to eq('my_new_user')
        expect(@elastic_endpoint.password).to eq('my_new_password')
      end

      it 'redirects to the index method' do
        put elastic_endpoint_path(@elastic_endpoint), params: {elastic_endpoint: FactoryBot.attributes_for(:elastic_endpoint)}
        expect(current_path).to redirect_to(elastic_endpoints_path)
      end
    end

    context 'invalid attributes' do
      it 'does not modify the model' do
        put elastic_endpoint_path(@elastic_endpoint), params: {elastic_endpoint: FactoryBot.attributes_for(:invalid_elastic_endpoint)}
        expect(assigns(:elastic_endpoint)).to eq @elastic_endpoint
      end

      it 're-renders the edit template' do
        put elastic_endpoint_path(@elastic_endpoint), params: {elastic_endpoint: FactoryBot.attributes_for(:invalid_elastic_endpoint)}
        expect(current_path).to render_template(:edit)
      end

      it 'rejects an invalid attribute' do
        put elastic_endpoint_path(@elastic_endpoint),
            params: {elastic_endpoint: FactoryBot.attributes_for(
              :elastic_endpoint, name: 'My New Name', address: ''
            )}
        @elastic_endpoint.reload
        expect(@elastic_endpoint.name).to eq('My Sample Elastic Endpoint')
        expect(@elastic_endpoint.address).to_not eq nil
      end
    end
  end

  describe 'DELETE' do
    before(:each) do
      login_admin
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint)
    end

    it 'deletes the model' do
      expect do
        delete elastic_endpoint_path(@elastic_endpoint)
      end.to change(ElasticEndpoint, :count).by(-1)
    end

    it 'redirects to the index method' do
      delete elastic_endpoint_path(@elastic_endpoint)
      expect(current_path).to redirect_to(elastic_endpoints_path)
    end
  end

  describe 'SHOW' do
    before(:each) do
      login_admin
      @elastic_endpoint = FactoryBot.create(:elastic_endpoint)
    end

    it 'redirects to the index method' do
      get elastic_endpoint_path(@elastic_endpoint)
      expect(current_path).to redirect_to(elastic_endpoints_path)
    end
  end
end