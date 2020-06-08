# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :request do
  describe 'default denies access to searches', type: :request do
    it do
      get new_search_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'factory' do
    it 'is valid' do
      @search = FactoryBot.create(:search)
      expect(@search).to be_valid
    end
  end

  describe 'GET' do
    before(:each) do
      login_admin
    end

    it '#index' do
      get searches_path
      expect(response).to render_template(:index)
    end

    # context 'has no elastic endpoints' do
    #   it 'redirects #new' do
    #     get new_search_path
    #     expect(current_path).to redirect_to(elastic_endpoints_path)
    #   end
    # end

    context 'has elastic endpoints' do
      before(:each) do
        @elastic_endpoint = FactoryBot.create(:elastic_endpoint)
      end
      it '#new assigns a new class' do
        get new_search_path
        expect(assigns(:search)).to be_a_new(Search)
      end

      it '#edit' do
        @search = FactoryBot.create(:search)
        get edit_search_path(@search)
        expect(response).to render_template(:edit)
      end

      it '#edit assigns class appropriately' do
        search = FactoryBot.create(:search)
        get edit_search_path(search)
        expect(assigns(:search)).to eq(search)
      end
    end
  end

  describe 'POST' do
    before(:each) do
      login_admin
      @elastic_endpoint = ElasticEndpoint.first || FactoryBot.create(:elastic_endpoint)
      @search = FactoryBot.attributes_for(:search, elastic_endpoint_id: @elastic_endpoint.id)
    end

    context 'valid attributes' do
      it 'redirects to index page' do
        post searches_path, params: {search: @search}
        expect(current_path).to redirect_to(searches_path)
      end

      it 'expects the count to increase by 1' do
        expect do
          post searches_path, params: {search: @search}
        end.to change(Search, :count).by(1)
      end
    end

    context 'invalid attributes' do
      it 'does not create the model' do
        expect do
          post searches_path, params: {search: FactoryBot.attributes_for(:invalid_search)}
        end.not_to change { Search.count }
      end
    end
  end

  describe 'PUT' do
    before(:each) do
      login_admin
      @search = FactoryBot.create(:search)
    end

    context 'valid attributes' do
      it 'located the model' do
        put search_path(@search), params: {search: FactoryBot.attributes_for(:search)}
        expect(assigns(:search)).to eq @search
      end

      it 'changes attributes' do
        put search_path(@search),
            params: {
              search: FactoryBot.attributes_for(
                :search,
                name: 'My New Name'
              )
            }
        @search.reload
        expect(@search.name).to eq('My New Name')
      end

      it 'redirects to the index method' do
        put search_path(@search), params: {search: FactoryBot.attributes_for(:search)}
        expect(current_path).to redirect_to(searches_path)
      end
    end

    context 'invalid attributes' do
      it 'does not modify the model' do
        put search_path(@search), params: {search: FactoryBot.attributes_for(:invalid_search)}
        expect(assigns(:search)).to eq @search
      end

      it 're-renders the edit template' do
        put search_path(@search), params: {search: FactoryBot.attributes_for(:invalid_search)}
        expect(current_path).to render_template(:edit)
      end

      it 'rejects an invalid attribute' do
        put search_path(@search),
            params: {search: FactoryBot.attributes_for(
              :search, name: 'My New Name', query: ' '
            )}
        @search.reload
        expect(@search.name).to eq('My Test Search')
        expect(@search.query).to_not eq ''
      end
    end
  end

  describe 'DELETE' do
    before(:each) do
      login_admin
      @search = FactoryBot.create(:search)
    end

    it 'deletes the model' do
      expect do
        delete search_path(@search)
      end.to change(Search, :count).by(-1)
    end

    it 'redirects to the index method' do
      delete search_path(@search)
      expect(current_path).to redirect_to(searches_path)
    end
  end
end